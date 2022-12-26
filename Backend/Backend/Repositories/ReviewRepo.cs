using Backend.Contexts;
using Backend.Models;
using Backend.Models.DTO.Review;
using Backend.Models.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


public interface IReviewRepo
{
    Task<PaginatedList<Review>> GetAllReviews();
    Task<Review> GetReview(int id);
    Task<IActionResult> DeleteReview(int id);
    Task<IActionResult> UpdateReview(int id, CreateReviewRequest update);
    Task<IActionResult> CreateReview(Review review);
}


namespace Backend.Repositories
{
    public class ReviewRepo : IReviewRepo
    {
        private readonly TawsilaContext _context;

        public ReviewRepo(TawsilaContext context)
        {
            _context = context;
        }

        public async Task<PaginatedList<Review>> GetAllReviews()
        {

            Review[] items = new Review[1];
            PaginatedList<Review> pagniatedListReviews = new PaginatedList<Review>(items,0,0);

            return pagniatedListReviews;
        }

        public async Task<Review> GetReview(int id)
        {
            var review = await _context.Reviews.FindAsync(id);
            return review;
        }

        public async Task<IActionResult> CreateReview(Review review)
        {
            _context.Reviews.Add(review);
            await _context.SaveChangesAsync();
            return new StatusCodeResult(200);
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

            return new StatusCodeResult(200);
        }

        public bool ReviewExists(int id)
        {
            return _context.Reviews.Any(e => e.Id == id);
        }

        public async Task<IActionResult> UpdateReview(int id, CreateReviewRequest update)
        {
            return new StatusCodeResult(200);
        }
    }
}
