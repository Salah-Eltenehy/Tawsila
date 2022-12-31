using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Services;

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
            var review = ReviewHelper.GetTestReview(1);
            mockUserService.Setup(x => x.GetUsers(It.IsAny<int[]>())).ReturnsAsync(new User[1]);
            var reviewReq = ReviewHelper.GetTestReviewRequest();
            mockRepo.Setup(x => x.CreateReview(It.IsAny<Review>())).ReturnsAsync(review);
            var reviewService = new ReviewService(mockRepo.Object);

            // Act
            var result = await reviewService.CreateReview(userId, reviewReq);


            // Assert
            review.WithDeepEqual(result)
            .IgnoreSourceProperty(x => x!.Id)
            .IgnoreSourceProperty(x => x!.CreatedAt)
            .IgnoreSourceProperty(x => x!.UpdatedAt)
            .Assert();
        }
    }
}
