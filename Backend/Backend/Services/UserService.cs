using Backend.Models.API.User;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Backend.Repositories;

namespace Backend.Services;

public interface IUserService
{
    public Task<User[]> GetUsers(int[] ids);
    public Task<string> LoginUser(LoginRequest req);
    public Task<string> RegisterUser(RegisterRequest req);
    public Task<string> VerifyUser(int id, string code, DateTime time);
    public Task<string> UpdateUser(int id, UpdateUserRequest req);
    public Task DeleteUser(int id, DeleteUserRequest req);
    public Task<IEnumerable<Car>> GetUserCars(int id);
    public Task<IEnumerable<Review>> GetUserReviews(int id, int offset, int pageSize);
}

public class UserService : IUserService
{
    private readonly UserRepo _userRepo;
    private readonly IJwtService _jwtService;
    private readonly IImageService _imageService;
    private readonly IStorageService _storageService;

    public UserService(UserRepo userRepo, IJwtService jwtService, IImageService imageService, IStorageService storageService)
    {
        _userRepo = userRepo;
        _jwtService = jwtService;
        _imageService = imageService;
        _storageService = storageService;
    }

    public async Task<User[]> GetUsers(int[] ids)
    {
        if (ids.Length > 1)
        {
            User[] users = await _userRepo.GetUsers(ids);

            for (int i = 0; i < users.Length; i++)
            {
                if (users[i].Avatar != "")
                {
                    users[i].Avatar = _storageService.GetBlobUrl("user-avatars", users[i].Avatar);
                }
            }
            return users;
        }

        User user = await _userRepo.GetUser(ids[0]);

        if (user.Avatar != "")
        {
            user.Avatar = _storageService.GetBlobUrl("user-avatars", user.Avatar);
        }
            
        return new User[] { user };
    }

    public async Task<string> LoginUser(LoginRequest req)
    {
        try
        {
            User user = await _userRepo.GetUser(req.Email);
            if (!BCrypt.Net.BCrypt.Verify(req.Password, user.Password))
            {
                throw new UnauthorizedException("Invalid email or password");
            }

            if (!user.IsEmailVerified)
            {
                return await _jwtService.SendVerificationCode(user);
            }

            if (user.Avatar != "")
            {
                user.Avatar = _storageService.GetBlobUrl("user-avatars", user.Avatar);
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

        string hashedPassword = BCrypt.Net.BCrypt.HashPassword(req.Password);
        User user = new()
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

    public async Task<string> UpdateUser(int id, UpdateUserRequest req)
    {
        string? avatar = req.Avatar;
        string? avatarFileName = null;
        if (avatar != null)
        {
            Stream avatarStream = new MemoryStream(_imageService.DecodeBase64(avatar));
            avatarFileName = await _storageService.UploadStream("user-avatars", avatarStream, ".jpg");
        }
        User user = await _userRepo.UpdateUser(id, req with { Avatar = avatarFileName });
        if (user.Avatar != "")
        {
            user.Avatar = _storageService.GetBlobUrl("user-avatars", user.Avatar);
        }
        return _jwtService.IssueToken(user, DateTime.UtcNow);
    }

    public async Task<string> VerifyUser(int id, string code, DateTime time)
    {
        User user = await _userRepo.GetUser(id);
        var correctCode = _jwtService.GetVerificationCode(user.Email, time);
        if (code != correctCode)
            throw new UnauthorizedException("Invalid or expired verification code");
        User verifiedUser = await _userRepo.VerifyUser(id);
        return _jwtService.IssueToken(verifiedUser, DateTime.UtcNow);
    }

    public async Task DeleteUser(int id, DeleteUserRequest req)
    {
        User user = await _userRepo.GetUser(id);
        if (!BCrypt.Net.BCrypt.Verify(req.Password, user.Password))
        {
            throw new UnauthorizedException("Invalid password");
        }

        await _userRepo.DeleteUser(id);
    }

    public async Task<IEnumerable<Car>> GetUserCars(int id)
    {
        Car[] cars = await _userRepo.GetUserCars(id);
        for (int i = 0; i < cars.Length; i++)
        {
            cars[i].Images = _storageService.GetBlobsUrls("car-images", cars[i].Images);
        }
        return cars;
    }

    public async Task<IEnumerable<Review>> GetUserReviews(int id, int offset, int pageSize)
    {
        return await _userRepo.GetReviews(id, offset, pageSize);
    }
}
