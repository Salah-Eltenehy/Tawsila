using Backend.Contexts;
using Backend.Models.DTO.Review;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Microsoft.EntityFrameworkCore;

namespace Backend.Repositories;

public interface IReviewRepo
{
    Task <Review> GetReview(int id);
    Task DeleteReview(int id);
    Task<Review> UpdateReview(int id, UpdateReviewRequest update);
    Task<Review> CreateReview(Review review);
}

public class ReviewRepo : IReviewRepo
{
    private readonly TawsilaContext _context;

    public ReviewRepo(TawsilaContext context)
    {
        _context = context;
    }
    
    public async Task<Review> GetReview(int id)
    {
        var review = await _context.Reviews.FindAsync(id);
        if (review == null || review.IsDeleted)
        {
            throw new NotFoundException("Review not found");
        }

        return review;
    }

    public async Task<Review> CreateReview(Review review)
    {
        Review trackedReview = (Review)review.Clone();
        _context.Reviews.Add(trackedReview);
        await _context.SaveChangesAsync();
        _context.Entry(trackedReview).State = EntityState.Detached;
        return trackedReview;
    }

    public bool ReviewExists(int id)
    {
        return _context.Reviews.Any(e => e.Id == id && !e.IsDeleted);
    }

    public async Task<Review> UpdateReview(int id, UpdateReviewRequest req)
    {
        var review = await _context.Reviews.FindAsync(id);
        if (review == null || review.IsDeleted)
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

    public async Task DeleteReview(int id)
    {
        var review = await _context.Reviews.FindAsync(id);
        if (review == null || review.IsDeleted)
        {
            throw new NotFoundException("Review not found");
        }

        review.IsDeleted = true;
        await _context.SaveChangesAsync();
    }
}
