using Backend.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DeepEqual.Syntax;
using Moq;

namespace Tests.Reviews.Controller
{
    public class GetAllReviews
    {

        [Fact]
        public async void GetAllReviewsTest_ReturnsListOfReviews()
        {
            // Arrange
            var controllerContext = ReviewHelper.GetTestIdentity();
            var mockService = new Mock<IReviewService>();
            var carList = ReviewHelper.GetPaginatedReviewsList();
            mockService.Setup(x => x.GetAllReviews());//.ReturnsAsync(carList)) ;
            var reviewController = new ReviewsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await reviewController.GetAllReviews();

            // Assert
            Assert.NotNull(result);
            Assert.True(carList.IsDeepEqual(result));
        }

        }
    }
