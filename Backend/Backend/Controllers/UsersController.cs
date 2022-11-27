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
        public async Task<string> UpdateUser(int id, RegisterRec update_user)
        {


            return "Not implemented";
        }


        
        [HttpPost("login")]
        public async Task<string> Login(LoginRec log)
        {
            User user = new User();
            user.email = log.email;
            user.password = log.password;
            _userRepo.Login(user);
            return "LOG IN NOT IMPLEMENTED";
        }

        [HttpPost]
        public async Task<string> RegisterUser(RegisterRec register)
        {
            // Console.WriteLine(register.LastName);
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
                return e.Message;
            }
            
            return "OK";
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

        [HttpGet("reviews/{id}")]
        public async Task<IEnumerable<Review>> GetOpinions(int id)
        {
            
             return await _userRepo.GetReviews(id);
        }
    }
}
