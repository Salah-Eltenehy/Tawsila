using Backend.Models.DTO.Review;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Backend.Repositories;

namespace Backend.Services;

public interface IReviewService
{
    Task<Review> GetReview(int reviewId);
    public Task<Review> CreateReview(int Userid, CreateReviewRequest review);
    public Task DeleteReview(int UserId, int id);
    public Task<Review> UpdateReview(int claimedId, int id, UpdateReviewRequest req);
}

public class ReviewService : IReviewService
{
    private IReviewRepo _reviewRepo;

    public ReviewService(IReviewRepo reviewRepo)
    {
        this._reviewRepo = reviewRepo;
    }

    public async Task<Review> GetReview(int reviewId)
    {
        Review review = await _reviewRepo.GetReview(reviewId);
        return review;
    }

    public async Task<Review> CreateReview(int userId, CreateReviewRequest reviewReq)
    {
        Review review = new()
        {
            Rating = reviewReq.Rating,
            Comment = reviewReq.Comment,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow,
            RevieweeId = reviewReq.Reviewee,
            ReviewerId = userId
        };
        return await _reviewRepo.CreateReview(review);
    }

    public async Task<Review> UpdateReview(int claimedId, int id, UpdateReviewRequest req)
    {
        try
        {
            Review review = await _reviewRepo.GetReview(id);
            if (review.ReviewerId != claimedId)
            {
                throw new UnauthorizedException("You can only update your reviews");
            }

            return await _reviewRepo.UpdateReview(id, req);
        }
        catch (NotFoundException)
        {
            throw new UnauthorizedException("You can only update your reviews");
        }
    }


    public async Task DeleteReview(int claimedId, int id)
    {
        try
        {
            Review review = await _reviewRepo.GetReview(id);
            if (review.ReviewerId != claimedId)
            {
                throw new UnauthorizedException("You can only delete your reviews");
            }

            await _reviewRepo.DeleteReview(id);
        }
        catch (NotFoundException)
        {
            throw new UnauthorizedException("You can only delete your reviews");
        }
    }
}
