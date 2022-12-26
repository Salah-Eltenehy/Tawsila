using Backend.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DeepEqual.Syntax;
using Backend.Services;

namespace Tests.Reviews.Service
{
    public class GetAllReviews
    {

        /*[Fact]
        public async void GetAllReviewsTest_ReturnsListOfReviews()
        {
            // Arrange
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var carList = ReviewHelper.GetReviewsList();
            mockRepo.Setup(x => x.GetAllReviews().ReturnsAsync(carList));
            var reivewService = new ReviewService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = await reivewService.GetAllReviews();

            // Assert
            Assert.NotNull(result);
            Assert.True(carList.IsDeepEqual(result));
        }*/
    }
 }
