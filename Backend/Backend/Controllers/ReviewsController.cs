using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Contexts;
using Backend.Models;
using Backend.Models.API.Review;
using Backend.Models.Entities;
using Backend.Repositories;

namespace Backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ReviewsController : ControllerBase
    {
        private readonly ReviewRepo _reviewRepo;

        public ReviewsController(ReviewRepo reviewRepo)
        {
            _reviewRepo = reviewRepo;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Review>>> GetReviews()
        {
            return await _reviewRepo.GetReviews();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Review>> GetReview(int id)
        {
            var review = await _reviewRepo.GetReview(id);   

            if (review == null)
            {
                return NotFound();
            }

            return review;
        }


        [HttpPost]
        public async Task<ActionResult<Review>> PostReview(ReviewRequest reviewRc)
        {
            Review review = new Review();
            review.RevieweeId = reviewRc.reviewee;
            review.Rating = reviewRc.rating;
            review.Comment = reviewRc.comment;
            review.ReviewerId = reviewRc.reviewer;
            await _reviewRepo.PostReview(review);

            return CreatedAtAction("GetReview", new { id = review.Id }, review);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReview(int id)
        {
            var review = await _reviewRepo.DeleteReview(id);
            if (review == null)
            {
                return NotFound();
            }

            return NoContent();
        }

        private bool ReviewExists(int id)
        {
            return _reviewRepo.ReviewExists(id);
        }
    }
}
