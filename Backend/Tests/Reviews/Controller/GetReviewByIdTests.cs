using Backend.Controllers;
using Backend.Models.Exceptions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tests.Reviews.Controller
{
    public class GetReviewByIdTests
    {

        [Fact]
        public async void GetReviewByIdTest_ReturnsCarWithTheSameId()
        {
            // Arrange 
            int id = 1;
            var mockService = new Mock<IReviewService>();
            var car = ReviewHelper.GetTestReview(id);
            mockService.Setup(x => x.GetReview(id)).ReturnsAsync(car);
            var reviewController = new ReviewsController(mockService.Object);

            // Act 
            var result = await reviewController.GetReview(id);

            // Assert
            Assert.NotNull(result);
            Assert.True(car.IsDeepEqual(result));
        }

        [Fact]
        public void GetReviewByIdTest_ReturnsNotFound()
        {
            // Arrange 
            int id = 1;
            var mockService = new Mock<IReviewService>();
            object value = mockService.Setup(x => x.GetReview(id)).Throws(new NotFoundException("")); ;
            var reivewController = new ReviewsController(mockService.Object);

            // Act
            var result = async () => await reivewController.GetReview(id);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }

    }
}
