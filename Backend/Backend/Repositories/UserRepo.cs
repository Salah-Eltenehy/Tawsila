using Backend.Contexts;
using Backend.Models.API.User;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Microsoft.EntityFrameworkCore;

namespace Backend.Repositories;

public interface IUserRepo
{
    bool IsUserExists(int id);
    bool IsUserExists(string email);
    Task<User> GetUser(int id);
    Task<User> GetUser(string email);
    Task<User[]> GetUsers(int[] ids);
    Task<User> RegisterUser(User user);
    Task<User> VerifyUser(int id);
    Task<User> UpdateUser(int id, UpdateUserRequest update);
    Task<User> UpdateUserPassword(int id, string password);
    Task DeleteUser(int id);
    Task<Car[]> GetUserCars(int id);
    Task<IEnumerable<Review>> GetReviews(int id, int offset, int limit);
    Task<double> GetAverageRating(int id);
}

public class UserRepo : IUserRepo
{
    private readonly TawsilaContext _context;

    public UserRepo(TawsilaContext context)
    {
        _context = context;
    }

    public bool IsUserExists(int id)
    {
        return _context.Users.Any(e => e.Id == id && !e.IsDeleted);
    }

    public bool IsUserExists(string email)
    {
        return _context.Users.Any(e => e.Email == email && !e.IsDeleted);
    }

    public async Task<User> GetUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null || user.IsDeleted)
        {
            throw new NotFoundException("User not found");
        }

        _context.Entry(user).State = EntityState.Detached;
        return user;
    }

    public async Task<User> GetUser(string email)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        if (user == null || user.IsDeleted)
        {
            throw new NotFoundException("User not found");
        }

        _context.Entry(user).State = EntityState.Detached;
        return user;
    }

    public async Task<User[]> GetUsers(int[] ids)
    {
        var users = await _context.Users
            .AsNoTracking()
            .Where(u => ids.Contains(u.Id) && !u.IsDeleted)
            .ToArrayAsync();
        if (users.Length != ids.Distinct().Count())
        {
            throw new NotFoundException("One or more users not found");
        }

        return users;
    }

    public async Task<User> RegisterUser(User user)
    {
        User trackedUser = (User)user.Clone();
        _context.Users.Add(trackedUser);
        trackedUser.CreatedAt = DateTime.UtcNow;
        trackedUser.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        _context.Entry(trackedUser).State = EntityState.Detached;
        return trackedUser;
    }

    public async Task<User> VerifyUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null || user.IsDeleted)
        {
            throw new NotFoundException("User not found");
        }

        user.IsEmailVerified = true;
        user.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        _context.Entry(user).State = EntityState.Detached;
        return user;
    }

    public async Task<User> UpdateUser(int id, UpdateUserRequest update)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null || user.IsDeleted)
        {
            throw new NotFoundException("User not found");
        }

        user.Email = update.Email;
        user.FirstName = update.FirstName;
        user.LastName = update.LastName;
        user.PhoneNumber = update.PhoneNumber;
        user.Avatar = update.Avatar ?? user.Avatar;
        user.HasWhatsapp = update.HasWhatsapp;
        user.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        _context.Entry(user).State = EntityState.Detached;
        return user;
    }

    public async Task<User> UpdateUserPassword(int id, string password)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null || user.IsDeleted)
        {
            throw new NotFoundException("User not found");
        }

        user.Password = password;
        user.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        _context.Entry(user).State = EntityState.Detached;
        return user;
    }

    public async Task DeleteUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null || user.IsDeleted)
        {
            throw new NotFoundException("User not found");
        }

        user.IsDeleted = true;
        await _context.SaveChangesAsync();
    }

    public async Task<Car[]> GetUserCars(int id)
    {
        var user = await _context.Users
            .AsNoTracking()
            .Include(u => u.Cars)
            .FirstOrDefaultAsync(u => u.Id == id);
        if (user == null || user.IsDeleted)
        {
            throw new NotFoundException("User not found");
        }

        return user.Cars.Where(c => !c.IsDeleted).ToArray();
    }

    public async Task<IEnumerable<Review>> GetReviews(int id, int offset, int limit)
    {
        var user = await _context.Users
            .AsNoTracking()
            .Include(u => u.Reviews)
            .FirstOrDefaultAsync(u => u.Id == id);
        if (user == null || user.IsDeleted)
        {
            throw new NotFoundException("User not found");
        }

        return user.Reviews
            .Where(r => r.RevieweeId == id && !r.IsDeleted)
            .Skip(offset)
            .Take(limit)
            .ToList();
    }

    public async Task<double> GetAverageRating(int id)
    {
        var user = await _context.Users
            .AsNoTracking()
            .Include(u => u.Reviews)
            .FirstOrDefaultAsync(u => u.Id == id);
        if (user == null || user.IsDeleted)
        {
            throw new NotFoundException("User not found");
        }

        if (user.Reviews.Any())
        {
            return user.Reviews.Average(r => r.Rating);
        }

        return 0;
    }
}
