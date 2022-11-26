using Backend.Contexts;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Backend.Repositories
{
    public class ReviewRepo
    {
        private readonly TawsilaContext _context;

        public ReviewRepo(TawsilaContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<IEnumerable<Review>>> GetReviews()
        {
            return await _context.Reviews.ToListAsync();
        }

        public async Task<Review> GetReview(int id)
        {
            var review = await _context.Reviews.FindAsync(id);

            if (review == null)
            {
                return null ;
            }

            return review;
        }

        public async Task<Review> PutReview(int id, Review review)
        {
            if (id != review.id)
            {
                return null;
            }

            _context.Entry(review).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ReviewExists(id))
                {
                    return null; 
                }
                else
                {
                    throw;
                }
            }

            return review;
        }

        public async Task PostReview(Review review)
        {
            _context.Reviews.Add(review);
            await _context.SaveChangesAsync();
        }

        public async Task<IActionResult> DeleteReview(int id)
        {
            var review = await _context.Reviews.FindAsync(id);
            if (review == null)
            {
                return null;
            }

            _context.Reviews.Remove(review);
            await _context.SaveChangesAsync();

            return null;
        }

        public bool ReviewExists(int id)
        {
            return _context.Reviews.Any(e => e.id == id);
        }
    }
}
