using Backend.AuthModels.Users;
using Backend.Models;
using Backend.Repositories;
using Microsoft.AspNetCore.Mvc;

public interface IUserService
{
    public Task<IEnumerable<User>> GetUsers();
    public Task<User> GetUser(int id);  
    public Task<IEnumerable<Review>> GetUserReviews(int id);
    public Task<ActionResult<User>> LoginUser(LoginRequest log);
    public Task<User> RegisterUser(RegisterRequest user);

    public Task<IActionResult> VerifyUser(int id, User user);
    public Task<User> UpdateUser(int id, UpdateRequest user);
    public Task<User> DeleteUser(int id);
}

namespace Backend.Services
{
    public class UserService : IUserService
    {
        private readonly UserRepo _userRepo;  

        public UserService(UserRepo userRepo)
        {
            _userRepo = userRepo;   
        }

        public async Task<User> DeleteUser(int id)
        {
           return await _userRepo.DeleteUser(id);
        }

        public async Task<IEnumerable<Review>> GetUserReviews(int id)
        {
            return await _userRepo.GetReviews(id);
        }

        public async Task<IEnumerable<User>> GetUsers()
        {
            return await _userRepo.GetAll();
        }

        public async Task<User> GetUser(int id)
        {
            return await _userRepo.GetUser(id);
        }

        public async Task<ActionResult<User>> LoginUser(LoginRequest log)
        {
           return await _userRepo.Login(log);
        }

        public async Task<User> RegisterUser(RegisterRequest register)
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
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
            return user;
        }

        public async Task<User> UpdateUser(int id, UpdateRequest user)
        {
            return await _userRepo.UpdateUser(id, user);
        }

        public Task<IActionResult> VerifyUser(int id, User user)
        {
            throw new NotImplementedException();
        }
    }
}
