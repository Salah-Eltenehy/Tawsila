using Backend.Models;
using Microsoft.AspNetCore.Mvc;

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
