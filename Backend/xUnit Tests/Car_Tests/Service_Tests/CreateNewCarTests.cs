using Backend.Models.Entities;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace xUnit_Tests.Car_Tests.Service_Tests
{
    public class CreateNewCarTests
    {
        [Fact]
        public async void CreateNewCarTest_ReturnsSuccess()
        {
            // Arrange
            int userId = 1;
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();

            mockUserService.Setup(x => x.GetUsers(It.IsAny<int[]>())).ReturnsAsync(new User[1]);
            var carReq = Helper.GetTestCarRequest();
            mockRepo.Setup(x => x.PostCar(It.IsAny<Car>())).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object, mockUserService.Object);
            
            // Act
            var result = await carService.CreateCar(userId, carReq);
            var okResult = result as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }
    }
}
