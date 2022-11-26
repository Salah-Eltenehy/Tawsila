using Backend.Models;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Services
{
    public interface IReviewService
    {
        public Task<ActionResult<IEnumerable<Review>>> GetUserReviews();
        public Task<IActionResult> CreateReview(int id, Review review);
        public Task<ActionResult<Review>> UpdateReview(Review review);
        public Task<IActionResult> DeleteReview(int id);
    }
}
