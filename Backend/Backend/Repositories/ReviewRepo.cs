using Backend.Contexts;
using Backend.Models;
using Backend.Models.DTO.Review;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Org.BouncyCastle.Ocsp;


public interface IReviewRepo
{
    Task <PaginatedList<Review>> GetAllReviews();
    Task <Review> GetReview(int id);
    Task DeleteReview(int id);
    Task<Review> UpdateReview(int id, UpdateReviewRequest update);
    Task<Review> CreateReview(Review review);
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

        public async Task<Review> CreateReview(Review review)
        {
            _context.Reviews.Add(review);
            await _context.SaveChangesAsync();
            return review;
        }

        public async Task DeleteReview(int id)
        {
            var review = await _context.Reviews.FindAsync(id);
            if (review == null)
            {
                throw new NotFoundException("Review not found");
            }

            _context.Reviews.Remove(review);
            await _context.SaveChangesAsync();
        }

        public bool ReviewExists(int id)
        {
            return _context.Reviews.Any(e => e.Id == id);
        }

        public async Task<Review> UpdateReview(int id, UpdateReviewRequest req)
        {
            var review = await _context.Reviews.FindAsync(id);
            if (review == null)
            {
                throw new NotFoundException("Review not found");
            }
            review.Rating = req.Rating;
            review.Comment = req.Comment;
            review.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
            _context.Entry(review).State = EntityState.Detached;
            return review;
        }
    }
}
