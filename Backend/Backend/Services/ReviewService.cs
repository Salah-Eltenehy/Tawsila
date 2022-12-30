using Backend.Models;
using Backend.Models.DTO.Review;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Backend.Repositories;
using Microsoft.AspNetCore.Mvc;
using System.Data;

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
    private IUserService _userService;

    public ReviewService(IReviewRepo reviewRepo, IUserService userService)
    {
        this._reviewRepo = reviewRepo;
        this._userService = userService;
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
        Review review = await _reviewRepo.GetReview(id);

        if (review == null || review.ReviewerId != claimedId)
        {
            throw new UnauthorizedException("You can only update your reviews");
        }
        return await _reviewRepo.UpdateReview(id, req);
    }


    public async Task DeleteReview(int userId, int ReviewId)
    {
        Review review = await _reviewRepo.GetReview(ReviewId);

        if (review == null || review.ReviewerId != userId)
        {
            throw new UnauthorizedException("You can only delete your reviews");
        }

        await _reviewRepo.DeleteReview(ReviewId);
    }
}
