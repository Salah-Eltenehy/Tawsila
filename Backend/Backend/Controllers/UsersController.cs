using System.Globalization;
using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Backend.Models.API;
using Backend.Models.API.User;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Diagnostics;
using Backend.Models.DTO.User;
using Backend.Services;

namespace Backend.Controllers;

[Route("[controller]")]
[ApiController]
public class UsersController : ControllerBase
{
    private readonly IUserService _userService;
    private readonly ILogger<UsersController> _logger;

    public UsersController(IUserService userService, ILogger<UsersController> logger)
    {
        _logger = logger;
        _userService = userService;
    }

    [Authorize(Policy = "VerifiedUser")]
    [HttpGet("{usersIds}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetUsers([FromRoute] string usersIds)
    {
        var usersIdsArray = usersIds.Split(',', StringSplitOptions.RemoveEmptyEntries).Select(int.Parse).ToArray();
        var users = await _userService.GetUsers(usersIdsArray);
        var userItems = users
            .Select(
                user =>
                    new UserItem(
                        user.Id,
                        user.FirstName,
                        user.LastName,
                        user.PhoneNumber,
                        user.Avatar,
                        user.HasWhatsapp,
                        user.CreatedAt.ToString(CultureInfo.CurrentCulture)
                    )
            )
            .ToArray();
        return Ok(new GetUsersResponse(userItems));
    }

    [AllowAnonymous]
    [HttpPost("login")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Login([FromBody] LoginRequest req)
    {
        var token = await _userService.LoginUser(req);
        return Ok(new TokenResponse(token));
    }

    [AllowAnonymous]
    [HttpPost("register")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Register([FromBody] RegisterRequest req)
    {
        var token = await _userService.RegisterUser(req);
        return Ok(new TokenResponse(token));
    }

    [AllowAnonymous]
    [HttpPost("recover/identify")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> RecoverIdentify([FromBody] RecoverIdentifyRequest req)
    {
        var token = await _userService.InitPasswordReset(req.Email);
        return Ok(new TokenResponse(token));
    }

    [Authorize(Policy = "UnverifiedPasswordResetter")]
    [HttpPost("recover/verify")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> RecoverVerify([FromBody] RecoverVerifyRequest req)
    {
        var claims = HttpContext.User.Claims.ToArray();
        var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
        var notBefore = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        notBefore = notBefore.AddSeconds(
            double.Parse(claims.First(c => c.Type == "nbf").Value, CultureInfo.InvariantCulture)
        );
        var token = await _userService.VerifyPasswordResetter(claimedId, req.VerificationCode, notBefore);
        return Ok(new TokenResponse(token));
    }
    
    [Authorize(Policy = "VerifiedPasswordResetter")]
    [HttpPost("recover/reset-password")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> RecoverResetPassword([FromBody] RecoverResetPasswordRequest req)
    {
        var claims = HttpContext.User.Claims;
        var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
        var token = await _userService.UpdateUserPassword(claimedId, req.Password);
        return Ok(new TokenResponse(token));
    }

    [Authorize(Policy = "UnverifiedUser")]
    [HttpPost("{id:int}/verify")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Verify(
        [FromRoute] int id,
        [FromBody] VerifyUserRequest req
    )
    {
        var claims = HttpContext.User.Claims.ToArray();
        var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
        if (id != claimedId)
        {
            return Unauthorized(new ErrorResponse("You can only verify your own account"));
        }

        var notBefore = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        notBefore = notBefore.AddSeconds(
            double.Parse(claims.First(c => c.Type == "nbf").Value, CultureInfo.InvariantCulture)
        );
        var token = await _userService.VerifyUser(id, req.EmailVerificationCode, notBefore);
        return Ok(new TokenResponse(token));
    }

    [Authorize(Policy = "VerifiedUser")]
    [HttpPut("{id:int}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateUser([FromRoute] int id, [FromBody] UpdateUserRequest update)
    {
        var claims = HttpContext.User.Claims;
        var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
        if (id != claimedId)
        {
            return Unauthorized(new ErrorResponse("You can only update your own account"));
        }

        var token = await _userService.UpdateUser(id, update);
        return Ok(new TokenResponse(token));
    }

    [Authorize(Policy = "VerifiedUser")]
    [HttpDelete("{id:int}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteUser([FromRoute] int id, [FromBody] DeleteUserRequest req)
    {
        var claims = HttpContext.User.Claims;
        var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
        if (id != claimedId)
        {
            return Unauthorized(new ErrorResponse("You can only delete your own account"));
        }

        await _userService.DeleteUser(id, req);
        return Ok(new GenericResponse("User deleted successfully"));
    }

    [Authorize(Policy = "VerifiedUser")]
    [HttpGet("{id:int}/cars")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetCars([FromRoute] int id)
    {
        var carsPaginatedList = await _userService.GetUserCars(id);
        var carItems = carsPaginatedList
            .Select(
                car =>
                    new UserCarItem(
                        car.Id,
                        car.Brand,
                        car.Model,
                        car.Year,
                        car.SeatsCount,
                        car.HasAirConditioning,
                        car.Price,
                        car.Images[0],
                        car.UpdatedAt
                    )
            )
            .ToArray();
        return Ok(new GetUserCarsResponse(carItems));
    }

    [Authorize(Policy = "VerifiedUser")]
    [HttpGet("{id:int}/reviews")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetReviews([FromRoute] int id, [FromRoute] int offset)
    {
        var ReviewsList = await _userService.GetUserReviews(id, offset);
        
        return Ok(ReviewsList);
    }

    [ApiExplorerSettings(IgnoreApi = true)]
    [Route("/error")]
    public IActionResult Error()
    {
        var context = HttpContext.Features.Get<IExceptionHandlerFeature>();
        var exception = context!.Error;
        switch (exception)
        {
            case NotFoundException:
                return NotFound(new GenericResponse(exception.Message));
            case UnauthorizedException:
                return Unauthorized(new GenericResponse(exception.Message));
            case ConflictException:
                return Conflict(new GenericResponse(exception.Message));
            case BadRequestException:
                return BadRequest(new GenericResponse(exception.Message));
            default:
                _logger.LogError(exception, "An unhandled exception occurred");
                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    new ErrorResponse("Internal server error")
                );
        }
    }
}
