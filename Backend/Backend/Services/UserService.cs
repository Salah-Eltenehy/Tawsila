using Backend.Models.API.User;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Backend.Repositories;

public interface IUserService
{
    public Task<User[]> GetUsers(int[] ids);
    public Task<string> LoginUser(LoginRequest req);
    public Task<string> RegisterUser(RegisterRequest req);
    public Task<string> VerifyUser(int id, string code, DateTime time);
    public Task<string> UpdateUser(int id, UpdateRequest req);
    public Task DeleteUser(int id, DeleteUserRequest req);
    public Task<IEnumerable<Review>> GetUserReviews(int id, int offset, int pageSize);
}

namespace Backend.Services
{
    public class UserService : IUserService
    {
        private readonly UserRepo _userRepo;
        private readonly IJwtService _jwtService;

        public UserService(UserRepo userRepo, IJwtService jwtService)
        {
            _userRepo = userRepo;
            _jwtService = jwtService;
        }

        public async Task<User[]> GetUsers(int[] ids)
        {
            if (ids.Length > 1)
            {
                return await _userRepo.GetUsers(ids);
            }

            return new[] { await _userRepo.GetUser(ids[0]) };
        }

        public async Task<string> LoginUser(LoginRequest req)
        {
            try
            {
                var user = await _userRepo.GetUser(req.Email);
                if (!BCrypt.Net.BCrypt.Verify(req.Password, user.Password))
                {
                    throw new UnauthorizedException("Invalid email or password");
                }

                if (!user.IsEmailVerified)
                {
                    return await _jwtService.SendVerificationCode(user);
                }

                return _jwtService.IssueToken(user, DateTime.UtcNow);
            }
            catch (Exception)
            {
                throw new UnauthorizedException("Invalid email or password");
            }
        }

        public async Task<string> RegisterUser(RegisterRequest req)
        {
            if (_userRepo.IsUserExists(req.Email))
            {
                throw new ConflictException("Email already registered");
            }

            var hashedPassword = BCrypt.Net.BCrypt.HashPassword(req.Password);
            var user = new User
            {
                Email = req.Email,
                Password = hashedPassword,
                FirstName = req.FirstName,
                LastName = req.LastName,
                PhoneNumber = req.PhoneNumber,
                HasWhatsapp = req.HasWhatsapp
            };
            await _userRepo.RegisterUser(user);
            return await _jwtService.SendVerificationCode(user);
        }

        public async Task<string> UpdateUser(int id, UpdateRequest req)
        {
            var user = await _userRepo.UpdateUser(id, req);
            return _jwtService.IssueToken(user, DateTime.UtcNow);
        }

        public async Task<string> VerifyUser(int id, string code, DateTime time)
        {
            var user = await _userRepo.GetUser(id);
            var correctCode = _jwtService.GetVerificationCode(user.Email, time);
            if (code != correctCode) throw new UnauthorizedException("Invalid or expired verification code");
            var verifiedUser = await _userRepo.VerifyUser(id);
            return _jwtService.IssueToken(verifiedUser, DateTime.UtcNow);
        }

        public async Task DeleteUser(int id, DeleteUserRequest req)
        {
            var user = await _userRepo.GetUser(id);
            if (!BCrypt.Net.BCrypt.Verify(req.Password, user.Password))
            {
                throw new UnauthorizedException("Invalid password");
            }

            await _userRepo.DeleteUser(id);
        }

        public async Task<IEnumerable<Review>> GetUserReviews(int id, int offset, int pageSize)
        {
            return await _userRepo.GetReviews(id, offset, pageSize);
        }
    }
}