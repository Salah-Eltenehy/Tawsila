using Backend.Models;
using Backend.Models.API.CarAPI;
using Backend.Models.DTO.Review;
using Backend.Models.Entities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace Tests.Reviews
{
    internal class ReviewHelper
    {

        public static Review GetTestReview(int id)
        {
            return new Review
            {
                Id = id,
                Rating = 5,
                Comment = "very specail experience",
                CreatedAt = DateTime.MinValue,
                UpdatedAt = DateTime.MinValue,
                ReviewerId =1,
                RevieweeId =1

    };
        }

        public static CreateReviewRequest GetTestReviewRequest()
        {
            return new CreateReviewRequest
            (
                4,"a very good car and service", 1
            );
        }

        public static UpdateReviewRequest GetTestUpdateReviewRequest()
        {
            return new UpdateReviewRequest
            (
                4, "Excellent service"
            );
        }

        public static IEnumerable<Review> GetEmptyReviewsList()
        {
            return new Review[] {};
        }


        public static ControllerContext GetTestIdentity()
        {
            var identity = new GenericIdentity("1", "1");
            var contextUser = new ClaimsPrincipal(identity);
            var httpContext = new DefaultHttpContext()
            {
                User = contextUser,
            };

            var controllerContext = new ControllerContext()
            {
                HttpContext = httpContext,
            };
            return controllerContext;
        }

        public static ActionResult<IEnumerable<Review>> GetReviewsList()
        {
            List<Review> ReviewsList = new()
            {
                GetTestReview(1),
                GetTestReview(2),
                GetTestReview(3)
            };
            return ReviewsList;
        }

        public static async Task<PaginatedList<Review>> GetPaginatedReviewsList()
        {
            Review[] items = new Review[1];
            PaginatedList<Review> pagniatedListReviews = new PaginatedList<Review>(items, 0, 0);

            return pagniatedListReviews;
        }


    }
}
