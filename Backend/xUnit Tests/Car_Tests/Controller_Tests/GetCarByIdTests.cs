using Backend.Controllers;
using Backend.Models.Exceptions;
using DeepEqual.Syntax;

namespace xUnit_Tests.Car_Tests.Controller_Tests
{
    public class GetCarByIdTest
    {
        [Fact]
        public async void GetCarByIdTest_ReturnsCarWithTheSameId()
        {
            // Arrange 
            int id = 1;
            var mockService = new Mock<ICarService>();
            var car = Helper.GetTestCar(id);
            mockService.Setup(x => x.GetCar(id)).ReturnsAsync(car);
            var carController = new CarsController(mockService.Object);

            // Act 
            var result = await carController.GetCar(id);

            // Assert
            Assert.NotNull(result);
            Assert.True(car.IsDeepEqual(result.Value));
        }

        [Fact]
        public void GetCarByIdTest_ReturnsNotFound()
        {
            // Arrange 
            int id = 1;
            var mockService = new Mock<ICarService>();
            object value = mockService.Setup(x => x.GetCar(id)).Throws(new NotFoundException("")); ;
            var carController = new CarsController(mockService.Object);

            // Act
            var result = async () => await carController.GetCar(id);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }
    }

}
