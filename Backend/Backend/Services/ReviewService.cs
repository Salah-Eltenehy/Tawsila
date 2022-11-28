using Backend.Models;
using Microsoft.AspNetCore.Mvc;

public interface IReviewService
{
    public Task<ActionResult<IEnumerable<Review>>> GetUserReviews();
    public Task<IActionResult> CreateReview(int id, Review review);
    public Task<ActionResult<Review>> UpdateReview(Review review);
    public Task<IActionResult> DeleteReview(int id);
}

namespace Backend.Services
{
    public class ReviewService : IReviewService
    {
        public Task<IActionResult> CreateReview(int id, Review review)
        {
            throw new NotImplementedException();
        }

        public Task<IActionResult> DeleteReview(int id)
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<IEnumerable<Review>>> GetUserReviews()
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<Review>> UpdateReview(Review review)
        {
            throw new NotImplementedException();
        }
    }
}
