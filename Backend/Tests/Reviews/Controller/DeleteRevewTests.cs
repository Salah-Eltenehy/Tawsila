using Backend.Controllers;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tests.Reviews.Controller
{
    public class DeleteRevewTests
    {
        [Fact]
        public async void DeleteReviewTest_ReturnsSuccess()
        {
            // Arrange 
            int reviewId = 1, userId = 1;
            var controllerContext = ReviewHelper.GetTestIdentity();
            var mockService = new Mock<IReviewService>();
            mockService.Setup(x => x.DeleteReview(userId, reviewId));
            var reviewController = new ReviewsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await reviewController.DeleteReview(reviewId);
            var okResult = result as OkObjectResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }

        [Fact]
        public void DeleteReivewTest_ReturnsNotFound()
        {
            // Arrange 
            int reviewId = 1, userId = 1;
            var controllerContext = ReviewHelper.GetTestIdentity();
            var mockService = new Mock<IReviewService>();
            mockService.Setup(x => x.DeleteReview(userId, reviewId)).Throws(new NotFoundException(""));
            var reviewController = new ReviewsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await reviewController.DeleteReview(reviewId);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result; ;
        }

        [Fact]
        public void DeleteReviewTest_ReturnsUnauthorized()
        {
            // Arrange 
            int reviewId = 1, userId = 1;
            var controllerContext = ReviewHelper.GetTestIdentity();
            var mockService = new Mock<IReviewService>();
            mockService.Setup(x => x.DeleteReview(userId, reviewId)).Throws(new UnauthorizedAccessException(""));
            var reviewController = new ReviewsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await reviewController.DeleteReview(reviewId);

            // Assert
            UnauthorizedAccessException exception = Assert.ThrowsAsync<UnauthorizedAccessException>(result).Result; ;
        }

    }
}
