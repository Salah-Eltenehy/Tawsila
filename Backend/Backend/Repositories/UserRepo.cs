using Backend.Contexts;
using Backend.Migrations;
using Backend.Models;
using Microsoft.AspNetCore.Identity;
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

        public User Login(LoginRec log)
        {
            var users = _context.Users.Where(e => e.email == log.email && e.password == log.password).ToList();
            if(users.Count() == 0)
            {
                return null;
            }
            User user = users[0];
            return user;
        }

        public async Task<User> UpdateUser(int id, UpdateRec update)
        {
            var user = await _context.Users.FindAsync(id);
            if(user == null)
            {
                return null;
            }
            user.email = update.email;
            user.firstName = update.FirstName;
            user.lastName = update.LastName;
            user.phoneNumber = update.Phone;
            user.hasWhatsapp = update.HasWhatsapp;
            _context.SaveChanges();
            return user;
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
            var user = await _context.Users.Include(p => p.reviews).SingleOrDefaultAsync(i => i.Id == id);
            if (user == null)
            {
                return null;
            }
            Console.WriteLine(user.reviews);
            return user.reviews;
        }

        public bool UserExists(int id)
        {
            return _context.Users.Any(e => e.Id == id);
        }
    }
}
