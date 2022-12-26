using Backend.Controllers;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tests.Reviews.Service
{
    public class CreateReviewTests
    {

        [Fact]
        public async void CreateNewReviewTest_ReturnsSuccess()
        {

            // Arrange
            int userId = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();

            mockUserService.Setup(x => x.GetUsers(It.IsAny<int[]>())).ReturnsAsync(new User[1]);
            var reviewReq = ReviewHelper.GetTestReviewRequest();
            mockRepo.Setup(x => x.CreateReview(It.IsAny<Review>())).ReturnsAsync(new StatusCodeResult(200));
            var reviewService = new ReviewService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = await reviewService.CreateReview(userId, reviewReq);
            var okResult = result as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }
    }
}
