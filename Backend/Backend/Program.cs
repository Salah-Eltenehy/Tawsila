using System.Net;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Backend.Contexts;
using Backend.Repositories;
using Backend.Controllers;
using System.Text.Json.Serialization;
using Backend.Models.API;
using Backend.Models.Settings;
using Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.Features;

var builder = WebApplication.CreateBuilder(args);
var configuration = builder.Configuration;

builder.Services.AddDbContext<TawsilaContext>(options =>
{
#if DEBUG
    options.UseInMemoryDatabase(databaseName: "TawsilaDB");
#else
    options.UseSqlServer(configuration.GetConnectionString("DefaultConnection"));
#endif
});

builder.Services.Configure<MailSettings>(configuration.GetSection("MailSettings"));
builder.Services.AddTransient<IMailService, MailService>();

builder.Services.AddControllers()
    .AddJsonOptions(options => options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles);

builder.Services.Configure<JwtSettings>(configuration.GetSection("JwtSettings"));
builder.Services.AddSingleton<IJwtService, JwtService>();
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.SaveToken = true;
    options.RequireHttpsMetadata = false;
    options.TokenValidationParameters = new TokenValidationParameters()
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidAudience = configuration["JwtSettings:Audience"],
        ValidIssuer = configuration["JwtSettings:Issuer"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JwtSettings:Secret"]))
    };
});

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("UnverifiedUser", policy =>
        policy.RequireClaim(ClaimTypes.Role, "UnverifiedUser"));
    options.AddPolicy("VerifiedUser", policy =>
        policy.RequireClaim(ClaimTypes.Role, "VerifiedUser"));
});

builder.Services.AddControllers();

builder.Services.AddScoped<UsersController>();
builder.Services.AddScoped<UserRepo>();
builder.Services.AddScoped<IUserService, UserService>();

builder.Services.AddScoped<CarsController>();
builder.Services.AddScoped<ICarService, CarService>();
builder.Services.AddScoped<CarRepo>();

builder.Services.AddScoped<ReviewsController>();
builder.Services.AddScoped<ReviewRepo>();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Wedding Planner API", Version = "v1" });
    var xmlFilename = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
    c.IncludeXmlComments(Path.Combine(AppContext.BaseDirectory, xmlFilename));
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = @"JWT Authorization header using the Bearer scheme. \r\n\r\n 
                      Enter 'Bearer' [space] and then your token in the text input below.
                      \r\n\r\nExample: 'Bearer 123'",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                },
                Scheme = "oauth2",
                Name = "Bearer",
                In = ParameterLocation.Header,
            },
            new List<string>()
        }
    });
});


var app = builder.Build();

app.UseExceptionHandler("/error");

app.UseSwagger();

if (app.Environment.IsDevelopment())
{
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.Use(async (context, next) =>
{
    await next();
    if (!context.Response.HasStarted)
    {
        context.Response.ContentType = "application/json";
        switch (context.Response.StatusCode)
        {
            case (int)HttpStatusCode.Unauthorized:
            {
                var res = new ErrorResponse("Login to access this resource");
                await context.Response.WriteAsync(JsonSerializer.Serialize(res));
                break;
            }
            case (int)HttpStatusCode.Forbidden:
            {
                var claims = context.User.Claims;
                var role = claims.FirstOrDefault(c => c.Type == ClaimTypes.Role)?.Value;
                context.Response.ContentType = "application/json";
                var res = new GenericResponse(
                    role switch
                    {
                        "UnverifiedUser" => "Please verify your email to access this resource",
                        "VerifiedUser" => "Your email is already verified",
                        _ => "You are not authorized to access this resource"
                    }
                );
                await context.Response.WriteAsync(JsonSerializer.Serialize(res));
                break;
            }
        }
    }
});

app.UseAuthentication();

app.UseAuthorization();

app.Use(async (context, next) =>
{
    var claims = context.User.Claims;
    var endpointFeatures = context.Features.Get<IEndpointFeature>()?.Endpoint?.Metadata;
    if (endpointFeatures != null && context.Request.Path != "/error")
    {
        var authorize = endpointFeatures.GetMetadata<AuthorizeAttribute>();
        if (authorize != null)
        {
            var userId = int.Parse(claims.FirstOrDefault(c => c.Type == ClaimTypes.Name)!.Value);
            var dbContext = context.RequestServices.GetRequiredService<TawsilaContext>();
            var user = dbContext.Users.Find(userId);
            if (user == null)
            {
                context.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                context.Response.ContentType = "application/json";
                var res = new ErrorResponse("Your account might have been deleted");
                await context.Response.WriteAsync(JsonSerializer.Serialize(res));
                await context.Response.CompleteAsync();
            }
            else
            {
                await next();
            }
        }
        else
        {
            await next();
        }
    }
    else
    {
        await next();
    }
});

app.MapControllers();

app.Run();