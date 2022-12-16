using Backend.Controllers;
using Backend.Models.Exceptions;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace xUnit_Tests.Car_Tests.Service_Tests
{
    public class DeleteCarTests
    {
        [Fact]
        public async void DeleteCarTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1;
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();
            var car = Helper.GetTestCar(1);
            mockRepo.Setup(x => x.GetCar(car.Id)).ReturnsAsync(car);
            mockRepo.Setup(x => x.DeleteCar(car)).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = await carService.DeleteCar(userId, car.Id);
            var okResult = result as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }

        [Fact]
        public void DeleteCarTest_ReturnsNotFound()
        {
            // Arrange 
            int carId = 1, userId = 1;
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();
            var car = Helper.GetTestCar(carId);
            mockRepo.Setup(x => x.GetCar(car.Id)).Throws(new NotFoundException(""));
            mockRepo.Setup(x => x.DeleteCar(car)).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = async () => await carService.DeleteCar(userId, carId);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result; ;
        }

        [Fact]
        public void DeleteCarTest_ReturnsUnauthorized()
        {
            // Arrange 
            int carId = 1, modifierId = 2;
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();
            var car = Helper.GetTestCar(carId);
            mockRepo.Setup(x => x.GetCar(car.Id)).ReturnsAsync(car);
            mockRepo.Setup(x => x.DeleteCar(car)).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = async () => await carService.DeleteCar(modifierId, carId);

            // Assert
            UnauthorizedAccessException exception = Assert.ThrowsAsync<UnauthorizedAccessException>(result).Result; ;
        }
    }
}
