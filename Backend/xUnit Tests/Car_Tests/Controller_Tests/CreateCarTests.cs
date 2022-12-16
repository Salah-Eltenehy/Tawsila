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
    public class CreateCarTests
    {
        [Fact]
        public async void CreateNewCarTest_ReturnsSuccess()
        {
            // Arrange
            var controllerContext = Helper.GetTestIdentity();
            var mockService = new Mock<ICarService>();
            var carReq = Helper.GetTestCarRequest();
            mockService.Setup(x => x.CreateCar(1, carReq));
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await carController.CreateNewCar(carReq);
            var okResult = result as OkObjectResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }

        [Fact]
        public void CreateNewCarTest_UserNotFound_ReturnsException()
        {
            // Arrange
            var mockService = new Mock<ICarService>();
            var carReq = Helper.GetTestCarRequest();
            mockService.Setup(x => x.CreateCar(1, carReq)).Throws(new NotFoundException("User not found"));
            var controllerContext = Helper.GetTestIdentity();
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = async () => await carController.CreateNewCar(carReq);

            // Assert
            NotFoundException exception = Assert.ThrowsAsync<NotFoundException>(result).Result;
        }
    }
}
