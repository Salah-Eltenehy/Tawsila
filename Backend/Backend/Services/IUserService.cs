using Backend.Models;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Services
{
    public interface IUserService
    {
        public Task<ActionResult<IEnumerable<User>>> GetUsers();
        public Task<ActionResult<IEnumerable<Review>>> GetUserReviews();
        public Task<ActionResult<User>> LoginUser(int id);
        public Task<IActionResult> RegisterUser(int id, User user);

        public Task<IActionResult> VerifyUser(int id, User user);
        public Task<ActionResult<User>> UpdateUser(User user);
        public Task<IActionResult> DeleteUser(int id);

    }
}
