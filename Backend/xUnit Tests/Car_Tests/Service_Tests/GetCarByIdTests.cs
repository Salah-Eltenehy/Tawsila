using Backend.Controllers;
using Backend.Models.Exceptions;
using Backend.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace xUnit_Tests.Car_Tests.Service_Tests
{
    public class GetCarByIdTests
    {
        [Fact]
        public async void GetCarByIdTest_ReturnsCarWithTheSameId()
        {
            // Arrange 
            int id = 1;
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();
            var car = Helper.GetTestCar(id);
            mockRepo.Setup(x => x.GetCar(id)).ReturnsAsync(car);
            var carService = new CarService(mockRepo.Object, mockUserService.Object);

            // Act 
            var result = await carService.GetCar(id);

            // Assert
            Assert.NotNull(result);
            Assert.True(car.IsDeepEqual(result.Value));
        }

        [Fact]
        public void GetCarByIdTest_ReturnsNotFound()
        {
            // Arrange 
            int id = 1;
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();
            var carService = new CarService(mockRepo.Object, mockUserService.Object);
            mockRepo.Setup(x => x.GetCar(id)).Throws(new NotFoundException("")); ;

            // Act
            var result = async () => await carService.GetCar(id);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }
    }
}
