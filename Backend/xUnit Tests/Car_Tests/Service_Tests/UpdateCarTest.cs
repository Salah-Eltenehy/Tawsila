using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using xUnit_Tests.Car_Tests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Backend.Controllers;
using Backend.Models.Exceptions;

namespace xUnit_Tests.Car_Tests.Service_Tests
{
    public class UpdateCarTest
    {

        [Fact]
        public async void UpdateCarTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1;
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();
            var car = Helper.GetTestCar(1);
            var carReq = Helper.GetTestCarRequest();
            mockRepo.Setup(x => x.GetCar(car.Id)).ReturnsAsync(car);
            mockRepo.Setup(x => x.PutCar(car.Id, car)).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object, mockUserService.Object);


            // Act
            var result = await carService.UpdateCar(userId, car.Id, carReq);
            var ok = result as StatusCodeResult;

            // Assert
            Assert.NotNull(ok);
            Assert.Equal(200, ok.StatusCode);
        }

        [Fact]
        public void UpdateCarTest_CarNotFound()
        {
            // Arrange 
            int userId = 1;
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();
            var car = Helper.GetTestCar(1);
            var carReq = Helper.GetTestCarRequest();
            mockRepo.Setup(x => x.GetCar(car.Id)).Throws(new NotFoundException(""));
            mockRepo.Setup(x => x.PutCar(car.Id, car)).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = async () => await carService.UpdateCar(userId, car.Id, carReq);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }


        [Fact]
        public void UpdateCarTest_ReturnsUnauthorized()
        {
            // Arrange 
            int carId = 1, modifierId = 2;
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();
            var car = Helper.GetTestCar(carId);
            var carReq = Helper.GetTestCarRequest();
            mockRepo.Setup(x => x.GetCar(car.Id)).ReturnsAsync(car);
            mockRepo.Setup(x => x.PutCar(car.Id, car)).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = async () => await carService.UpdateCar(modifierId, carId, carReq);

            // Assert
            UnauthorizedAccessException exception = Assert.ThrowsAsync<UnauthorizedAccessException>(result).Result; ;
        }

    }
}
