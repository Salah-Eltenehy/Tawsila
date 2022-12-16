using Backend.Controllers;
using Backend.Models.Exceptions;
using Backend.Repositories;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace xUnit_Tests.Car_Tests.Controller_Tests
{
    public class UpdateCarTests
    {
        [Fact]
        public async void UpdateCarTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1, carId = 1;
            var controllerContext = Helper.GetTestIdentity();
            var mockService = new Mock<ICarService>();
            var carRequest = Helper.GetTestCarRequest();
            mockService.Setup(x => x.UpdateCar(userId, carId, carRequest)).ReturnsAsync(new StatusCodeResult(200));
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await carController.UpdateCar(1, carRequest);

            var ok = result as OkObjectResult;

            // Assert
            Assert.NotNull(ok);
            Assert.Equal(200, ok.StatusCode);
        }

        [Fact]
        public void UpdateCarTest_CarNotFound()
        {
            // Arrange 
            int userId = 1, carId = 1;
            var controllerContext = Helper.GetTestIdentity();
            var mockService = new Mock<ICarService>();
            var carRequest = Helper.GetTestCarRequest();
            mockService.Setup(x => x.UpdateCar(userId, carId, carRequest)).Throws(new NotFoundException(""));
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await carController.UpdateCar(carId, carRequest);  

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }

        [Fact]
        public void UpdateCarTest_ReturnsUnauthorized()
        {
            // Arrange 
            int userId = 1, carId = 1;
            var controllerContext = Helper.GetTestIdentity();
            var mockService = new Mock<ICarService>();
            var carRequest = Helper.GetTestCarRequest();
            mockService.Setup(x => x.UpdateCar(userId, carId, carRequest)).Throws(new UnauthorizedAccessException(""));
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await carController.UpdateCar(carId, carRequest);

            // Assert
            UnauthorizedAccessException exception = Assert.ThrowsAsync<UnauthorizedAccessException>(result).Result;
        }
    }
}
