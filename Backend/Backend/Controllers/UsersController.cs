using System.Globalization;
using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Backend.Models.API;
using Backend.Models.API.User;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Diagnostics;

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
        var usersIdsArray = usersIds.Split(',').Select(int.Parse).ToArray();
        var users = await _userService.GetUsers(usersIdsArray);
        var userItems = users.Select(user => new UserItem(
            user.Id,
            user.FirstName,
            user.LastName,
            user.PhoneNumber,
            user.HasWhatsapp,
            user.CreatedAt.ToString(CultureInfo.CurrentCulture)
        )).ToArray();
        var res = new GetUsersResponse(userItems);
        return Ok(res);
    }

    [HttpPost("login")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<TokenResponse>> Login([FromBody] LoginRequest req)
    {
        var token = await _userService.LoginUser(req);
        return Ok(new TokenResponse(token));
    }

    [HttpPost("register")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult<TokenResponse>> Register([FromBody] RegisterRequest req)
    {
        var token = await _userService.RegisterUser(req);
        return Ok(new TokenResponse(token));
    }

    [Authorize(Policy = "UnverifiedUser")]
    [HttpPost("{id:int}/verify")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TokenResponse>> Verify([FromRoute] int id, [FromBody] VerifyUserRequest req)
    {
        var claims = HttpContext.User.Claims.ToArray();
        var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
        if (id != claimedId)
        {
            return Unauthorized(new ErrorResponse("You can only verify your own account"));
        }

        var notBefore = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        notBefore = notBefore.AddSeconds(double.Parse(claims.First(c => c.Type == "nbf").Value,
            CultureInfo.InvariantCulture));
        var token = await _userService.VerifyUser(id, req.EmailVerificationCode, notBefore);
        return Ok(new TokenResponse(token));
    }

    [Authorize(Policy = "VerifiedUser")]
    [HttpPut("{id:int}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateUser([FromRoute] int id, [FromBody] UpdateRequest update)
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
            default:
                _logger.LogError(exception, "An unhandled exception occurred");
                return StatusCode(StatusCodes.Status500InternalServerError,
                    new ErrorResponse("Internal server error"));
        }
    }
}