using Backend.Controllers;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tests.Reviews.Service
{
    public class UpdateReviewTests
    {

        [Fact]
        public async void UpdateReviewTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(1);
            var reviewReq = ReviewHelper.GetTestUpdateReviewRequest();
            mockRepo.Setup(x => x.GetReview(review.Id)).ReturnsAsync(review);
   
            mockRepo.Setup(x => x.UpdateReview(review.Id, reviewReq)).ReturnsAsync(review);
            var reviewService = new ReviewService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = await reviewService.UpdateReview(userId, review.Id, reviewReq);


            // Assert
            review.WithDeepEqual(result)
            .IgnoreSourceProperty(x => x!.Id)
            .IgnoreSourceProperty(x => x!.CreatedAt)
            .IgnoreSourceProperty(x => x!.UpdatedAt)
            .Assert();
        }

        [Fact]
        public void UpdateReviewTest_CarNotFound()
        {
            // Arrange 
            int userId = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(1);
            var reviewReq = ReviewHelper.GetTestUpdateReviewRequest();
            mockRepo.Setup(x => x.GetReview(review.Id)).Throws(new NotFoundException(""));
            mockRepo.Setup(x => x.UpdateReview(review.Id, reviewReq));
            var carService = new ReviewService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = async () => await carService.UpdateReview(userId, review.Id, reviewReq);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }


        [Fact]
        public void UpdateReviewTest_ReturnsUnauthorized()
        {
            // Arrange 
            int reviewId = 1, modifierId = 2;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(reviewId);
            var reviewReq = ReviewHelper.GetTestUpdateReviewRequest();
            mockRepo.Setup(x => x.GetReview(review.Id)).ReturnsAsync(review);
            mockRepo.Setup(x => x.UpdateReview(review.Id, reviewReq));
            var carService = new ReviewService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = async () => await carService.UpdateReview(modifierId, reviewId, reviewReq);

            // Assert
            UnauthorizedAccessException exception = Assert.ThrowsAsync<UnauthorizedAccessException>(result).Result; ;
        }

    }
}
