using Backend.Models;
using Backend.Models.DTO.Review;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Mvc;

public interface IReviewService
{
    Task<PaginatedList<Review>> GetAllReviews();
    Task<Review> GetReview(int reviewId);
    public Task<IActionResult> CreateReview(int Userid, CreateReviewRequest review);
    public Task<IActionResult> DeleteReview(int UserId, int id);
    Task<IActionResult> UpdateReview(int claimedId, int id, CreateReviewRequest req);
}

namespace Backend.Services
{
    public class ReviewService : IReviewService
    {
        private IReviewRepo _reviewRepo;
        private IUserService _userService;

        public ReviewService(IReviewRepo reviewRepo, IUserService userService)
        {
            this._reviewRepo = reviewRepo;
            this._userService = userService;
        }

        public async Task<PaginatedList<Review>> GetAllReviews()
        {
            PaginatedList<Review> reviews = await _reviewRepo.GetAllReviews();

            return reviews;
        }

        public async Task<Review> GetReview(int reviewId)
        {
            Review review = await _reviewRepo.GetReview(reviewId);
            return review;
        }

        public async Task<IActionResult> CreateReview(int UserId, CreateReviewRequest reviewReq)
        {

            Review review = new()
            {
                Rating = reviewReq.Rating,
                Comment = reviewReq.Comment,
                CreatedAt = reviewReq.CreatedAt,
                UpdatedAt = reviewReq.UpdatedAt,
                RevieweeId = reviewReq.RevieweeId,
                ReviewerId = UserId
            };
           return  await _reviewRepo.CreateReview(review);
        }


        public async Task<IActionResult> DeleteReview(int UserId, int ReviewId)
        {
            Review review = await _reviewRepo.GetReview(ReviewId);
            if (review == null)
            {
                throw new NotFoundException("Car not found");
            }

            if (review.ReviewerId != UserId)
            {
                throw new UnauthorizedException("You can only Delete your cars");
            }

            return await _reviewRepo.DeleteReview(ReviewId);
        }

        public async Task<IActionResult> UpdateReview(int claimedId, int id, CreateReviewRequest req)
        {
            Review review = await _reviewRepo.GetReview(id);
            if (review == null)
            {
                throw new NotFoundException("Car not found");
            }

            if (review.ReviewerId != claimedId)
            {
                throw new UnauthorizedAccessException("You can only update your cars");
            }

            return await _reviewRepo.UpdateReview(id, req);
            
        }

        /*public Task UpdateReview(int claimedId, int id, CreateReviewRequest req)
        {
            throw new NotImplementedException();
        }*/


        /*Task<Review> IReviewService.GetReview(int reviewId)
        {
            throw new NotImplementedException();
        }*/
    }
}
