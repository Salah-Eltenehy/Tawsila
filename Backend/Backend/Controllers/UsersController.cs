using Microsoft.AspNetCore.Mvc;
using Backend.Models;
using Backend.AuthModels.Users;
using Backend.Services;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IUserService _userService;

        public UsersController(UserService userService)
        {
            _userService = userService;
        }

        [HttpGet]  
        public async Task<IEnumerable<User>> GetAll()
        {
            return await _userService.GetUsers();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            var user = await _userService.GetUser(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, UpdateRequest update)
        {

            var user = await _userService.UpdateUser(id, update);
            if(user == null)
            {
                return BadRequest();
            }
            return Ok();
        }


        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginRequest log)
        {
            var user  = await _userService.LoginUser(log);
            if(user == null)
            {
                return NotFound();
            }
            return Ok();
        }

        [HttpPost]
        public async Task<IActionResult> RegisterUser(RegisterRequest register)
        {
           
            User user = await _userService.RegisterUser(register);
            if (user == null)
            {
                return BadRequest();
            }
            
            return Ok();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _userService.DeleteUser(id);
            if (user == null)
            {
                return NotFound();
            }
            return Ok();
        }

        [HttpGet("{id}/reviews")]
        public async Task<IEnumerable<Review>> GetOpinions(int id)
        {
             return await _userService.GetUserReviews(id);
        }
    }
}
