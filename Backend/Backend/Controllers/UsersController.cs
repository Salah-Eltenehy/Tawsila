using Microsoft.AspNetCore.Mvc;
using Backend.Models;
using Backend.Repositories;
using Microsoft.Win32;
using System.Web;
using System.Net.WebSockets;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly UserRepo _userRepo;

        public UsersController(UserRepo userRepo)
        {
            _userRepo = userRepo;
        }

        [HttpGet]  
        public async Task<IEnumerable<User>> GetAll()
        {
            return await _userRepo.GetAll();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            var user = await _userRepo.GetUser(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, UpdateRec update)
        {

            var user = await _userRepo.UpdateUser(id, update);
            if(user == null)
            {
                return BadRequest();
            }
            return Ok();
        }


        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginRec log)
        {
            var user  = _userRepo.Login(log);
            if(user == null)
            {
                return NotFound();
            }
            return Ok();
        }

        [HttpPost]
        public async Task<IActionResult> RegisterUser(RegisterRec register)
        {
            User user = new User();
            user.email = register.email;
            user.firstName = register.FirstName;
            user.phoneNumber = register.phone;
            user.hasWhatsapp = register.hasWhatsapp;
            user.lastName = register.LastName;
            user.password = register.password;
            try
            {
                await _userRepo.RegisterUser(user);
            }catch(Exception e)
            {
                return BadRequest();
            }
            
            return Ok();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _userRepo.DeleteUser(id);
            if (user == null)
            {
                return NotFound();
            }
            return Ok();
        }

        // API to get the opinions on the user
        [HttpGet("reviews/{id}")]
        public async Task<IEnumerable<Review>> GetOpinions(int id)
        {
            
             return await _userRepo.GetReviews(id);
        }
    }
}
