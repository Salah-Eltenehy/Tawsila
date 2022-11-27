using Backend.Contexts;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace Backend.Repositories
{
    public class UserRepo
    {
        private readonly TawsilaContext _context;

        public UserRepo(TawsilaContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<User>> GetAll()
        {
           return await _context.Set<User>().ToListAsync();
        }

        public async Task<User> GetUser(int id)
        {
            return await _context.Users.FindAsync(id);
        }

        public void Login(User user)
        {
            // to do 
            // 
         
        }

        public async Task RegisterUser(User user)
        {
            _context.Users.Add(user);
            await _context.SaveChangesAsync();
        }

        public async Task<User> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return null;
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return user;
        }

        public async Task<IEnumerable<Review>> GetReviews(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return null;
            }
            Console.WriteLine(user.reviews);
            return user.reviews;
        }

        public bool UserExists(int id)
        {
            return _context.Users.Any(e => e.userId == id);
        }
    }
}
