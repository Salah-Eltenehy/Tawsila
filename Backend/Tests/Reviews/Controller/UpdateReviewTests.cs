using Backend.Controllers;
using Backend.Models.Exceptions;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tests.Reviews.Controller
{
    public class UpdateReviewTests
    {

        [Fact]
        public async void UpdateCarTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1, ReviewId = 1;
            var controllerContext = ReviewHelper.GetTestIdentity();
            var mockService = new Mock<IReviewService>();
            var reivewRequest = ReviewHelper.GetTestUpdateReviewRequest();
            mockService.Setup(x => x.UpdateReview(userId, ReviewId, reivewRequest));//.Returns(new StatusCodeResult(200));
            var reviewController = new ReviewsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await reviewController.UpdateReview(1, reivewRequest);

            var ok = result as OkObjectResult;

            // Assert
            Assert.NotNull(ok);
            Assert.Equal(200, ok.StatusCode);
        }

        [Fact]
        public void UpdateCarTest_CarNotFound()
        {
            // Arrange 
            int userId = 1, ReviewId = 1;
            var controllerContext = ReviewHelper.GetTestIdentity();
            var mockService = new Mock<IReviewService>();
            var reivewRequest = ReviewHelper.GetTestUpdateReviewRequest();
            mockService.Setup(x => x.UpdateReview(userId, ReviewId, reivewRequest)).Throws(new NotFoundException(""));
            var reviewController = new ReviewsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await reviewController.UpdateReview(ReviewId, reivewRequest);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }

        [Fact]
        public void UpdateCarTest_ReturnsUnauthorized()
        {
            // Arrange 
            int userId = 1, ReviewId = 1;
            var controllerContext = ReviewHelper.GetTestIdentity();
            var mockService = new Mock<IReviewService>();
            var reivewRequest = ReviewHelper.GetTestUpdateReviewRequest();
            mockService.Setup(x => x.UpdateReview(userId, ReviewId, reivewRequest)).Throws(new UnauthorizedAccessException(""));
            var reviewController = new ReviewsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await reviewController.UpdateReview(ReviewId, reivewRequest);

            // Assert
            UnauthorizedAccessException exception = Assert.ThrowsAsync<UnauthorizedAccessException>(result).Result;
        }

    }
}
