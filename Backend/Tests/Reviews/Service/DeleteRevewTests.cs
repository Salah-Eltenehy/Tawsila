using Backend.Controllers;
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
    public class DeleteRevewTests
    {
        [Fact]
        public async void DeleteReviewTest_ReturnsSuccess()
        {
            // Arrange 
            int reviewId = 1, userId = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(1);
            mockRepo.Setup(x => x.GetReview(review.Id)).ReturnsAsync(review);
            mockRepo.Setup(x => x.DeleteReview(review.Id)).ReturnsAsync(new StatusCodeResult(200));
            var reviewService = new ReviewService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = await reviewService.DeleteReview(userId, reviewId);
            var okResult = result as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }

        [Fact]
        public void DeleteReviewTest_ReturnsNotFound()
        {
            // Arrange 
            int reivewId = 1, userId = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(reivewId);
            mockRepo.Setup(x => x.GetReview(review.Id)).Throws(new NotFoundException(""));
            mockRepo.Setup(x => x.DeleteReview(review.Id)).ReturnsAsync(new StatusCodeResult(200));
            var reviewService = new ReviewService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = async () => await reviewService.DeleteReview(userId, reivewId);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result; ;
        }

        [Fact]
        public void DeleteReviewTest_ReturnsUnauthorized()
        {
            // Arrange 
            int reivewId = 1, userId = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(reivewId);
            mockRepo.Setup(x => x.GetReview(review.Id)).ReturnsAsync(review);
            mockRepo.Setup(x => x.DeleteReview(review.Id)).ReturnsAsync(new StatusCodeResult(200));
            var reviewService = new ReviewService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = async () => await reviewService.DeleteReview(userId, reivewId);

            // Assert
            UnauthorizedAccessException exception = Assert.ThrowsAsync<UnauthorizedAccessException>(result).Result; ;
        }

    }
}
