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
    public class CreateReviewTests
    {

        [Fact]
        public async void CreateNewReviewTest_ReturnsSuccess()
        {
            // Arrange
            var controllerContext = ReviewHelper.GetTestIdentity();
            var mockService = new Mock<IReviewService>();
            var ReviewReq = ReviewHelper.GetTestReviewRequest();
            mockService.Setup(x => x.CreateReview(1, ReviewReq));
            var reviewController = new ReviewsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await reviewController.CreateReview(ReviewReq);
            var okResult = result as OkObjectResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }

        [Fact]
        public void CreateNewReviewTest_UserNotFound_ReturnsException()
        {
            // Arrange
            var mockService = new Mock<IReviewService>();
            var ReviewReq = ReviewHelper.GetTestReviewRequest();
            mockService.Setup(x => x.CreateReview(1, ReviewReq)).Throws(new NotFoundException("User not found"));
            var controllerContext = ReviewHelper.GetTestIdentity();
            var reviewController = new ReviewsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await reviewController.CreateReview(ReviewReq);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }
    }
}
