using Backend.Controllers;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace xUnit_Tests.Car_Tests.Controller_Tests
{
    public class DeleteCarTests
    {
        [Fact]
        public async void DeleteCarTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1, carId = 1;
            var controllerContext = Helper.GetTestIdentity();
            var mockService = new Mock<ICarService>();
            var carRequest =    Helper.GetTestCarRequest();
            mockService.Setup(x => x.DeleteCar(userId, carId));
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await carController.DeleteCar(1);
            var okResult = result as OkObjectResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }


        [Fact]
        public void DeleteCarTest_ReturnsNotFound()
        {
            // Arrange 
            int userId = 1, carId = 1;
            var controllerContext = Helper.GetTestIdentity();
            var mockService = new Mock<ICarService>();
            mockService.Setup(x => x.DeleteCar(userId, carId)).Throws(new NotFoundException(""));
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await carController.DeleteCar(carId);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result; ;
        }

        [Fact]
        public void DeleteCarTest_ReturnsUnauthorized()
        {
            // Arrange 
            int userId = 1, carId = 1;
            var controllerContext = Helper.GetTestIdentity();
            var mockService = new Mock<ICarService>();
            mockService.Setup(x => x.DeleteCar(userId, carId)).Throws(new UnauthorizedAccessException(""));
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await carController.DeleteCar(carId);

            // Assert
            UnauthorizedAccessException exception = Assert.ThrowsAsync<UnauthorizedAccessException>(result).Result; ;
        }
    }
}
