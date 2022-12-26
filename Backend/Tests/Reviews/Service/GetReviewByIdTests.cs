using Backend.Controllers;
using Backend.Models.Exceptions;
using Backend.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tests.Reviews.Service
{
    public class GetReviewByIdTests
    {

        [Fact]
        public async void GetReviewByIdTest_ReturnsReviewWithTheSameId()
        {
            // Arrange 
            int id = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(id);
            mockRepo.Setup(x => x.GetReview(id)).ReturnsAsync(review);
            var reviewService = new ReviewService(mockRepo.Object, mockUserService.Object);

            // Act 
            var result = await reviewService.GetReview(id);

            // Assert
            Assert.NotNull(result);
            Assert.True(review.IsDeepEqual(result));
        }

        [Fact]
        public void GetReviewByIdTest_ReturnsNotFound()
        {
            // Arrange 
            int id = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var reviewService = new ReviewService(mockRepo.Object, mockUserService.Object);
            mockRepo.Setup(x => x.GetReview(id)).Throws(new NotFoundException("")); ;

            // Act
            var result = async () => await reviewService.GetReview(id);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }

    }
}
