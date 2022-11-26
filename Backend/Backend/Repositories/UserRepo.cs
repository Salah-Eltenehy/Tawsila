using Backend.Contexts;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Backend.Repositories
{
    public class UserRepo
    {
        private readonly TawsilaContext _context;

        public UserRepo(TawsilaContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }

        public async Task<ActionResult<User>> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return null;
            }

            return user;
        }

        public async Task<User> PutUser(int id, User user)
        {
            if (id != user.userId)
            {
                return null;
            }

            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
                {
                    return null;
                }
                else
                {
                    throw;
                }
            }

            return user;
        }

        public async Task  PostUser(User user)
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

        public bool UserExists(int id)
        {
            return _context.Users.Any(e => e.userId == id);
        }
    }
}
