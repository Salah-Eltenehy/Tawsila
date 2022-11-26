using Backend.Models;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Services
{
    public class UserService : IUserService
    {
        public Task<IActionResult> DeleteUser(int id)
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<IEnumerable<Review>>> GetUserReviews()
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<User>> LoginUser(int id)
        {
            throw new NotImplementedException();
        }

        public Task<IActionResult> RegisterUser(int id, User user)
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<User>> UpdateUser(User user)
        {
            throw new NotImplementedException();
        }

        public Task<IActionResult> VerifyUser(int id, User user)
        {
            throw new NotImplementedException();
        }
    }
}
