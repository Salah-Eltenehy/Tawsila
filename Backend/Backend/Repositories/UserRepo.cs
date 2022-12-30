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
    Task RegisterUser(User user);
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
        return _context.Users.Any(e => e.Id == id);
    }

    public bool IsUserExists(string email)
    {
        return _context.Users.Any(e => e.Email == email);
    }

    public async Task<User> GetUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        return user;
    }

    public async Task<User> GetUser(string email)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        return user;
    }

    public async Task<User[]> GetUsers(int[] ids)
    {
        var users = await _context.Users.Where(u => ids.Contains(u.Id)).ToArrayAsync();
        if (users.Length != ids.Distinct().Count())
        {
            throw new NotFoundException("One or more users not found");
        }

        return users;
    }

    public async Task RegisterUser(User user)
    {
        _context.Users.Add(user);
        user.CreatedAt = DateTime.UtcNow;
        user.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
    }

    public async Task<User> VerifyUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        user.IsEmailVerified = true;
        user.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        return user;
    }

    public async Task<User> UpdateUser(int id, UpdateUserRequest update)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
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
        return user;
    }

    public async Task<User> UpdateUserPassword(int id, string password)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        user.Password = password;
        user.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        return user;
    }

    public async Task DeleteUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        _context.Users.Remove(user);
        await _context.SaveChangesAsync();
    }
    
    public async Task<Car[]> GetUserCars(int id)
    {
        var user = await _context.Users.Include(u => u.Cars).FirstOrDefaultAsync(u => u.Id == id);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        return user.Cars.ToArray();
    }

    public async Task<IEnumerable<Review>> GetReviews(int id, int offset, int limit)
    {
        return await _context.Reviews
            .Where(r => r.RevieweeId == id)
            .Skip(offset)
            .Take(limit)
            .ToListAsync();
    }
    
    public async Task<double> GetAverageRating(int userId)
    {
        var user = await _context.Users.FindAsync(userId);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        IQueryable<Review> reviews = _context.Reviews.Where(r => r.RevieweeId == userId);
        if (await reviews.AnyAsync())
        {
            return await reviews.AverageAsync(r => r.Rating);
        }

        return 0;
    }
}
