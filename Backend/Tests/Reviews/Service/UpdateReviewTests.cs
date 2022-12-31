using Backend.Models.Exceptions;
using Backend.Repositories;
using Backend.Services;

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
            var reviewService = new ReviewService(mockRepo.Object);

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
            var carService = new ReviewService(mockRepo.Object);

            // Act
            var result = async () => await carService.UpdateReview(userId, review.Id, reviewReq);

            // Assert
            UnauthorizedException exception = Assert.ThrowsAsync<UnauthorizedException>(result).Result;
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
            var carService = new ReviewService(mockRepo.Object);

            // Act
            var result = async () => await carService.UpdateReview(modifierId, reviewId, reviewReq);

            // Assert
            UnauthorizedException exception = Assert.ThrowsAsync<UnauthorizedException>(result).Result; ;
        }

    }
}
