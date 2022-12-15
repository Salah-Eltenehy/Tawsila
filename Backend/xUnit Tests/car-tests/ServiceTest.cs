using Backend.Controllers;
using Backend.Models.API.CarAPI;
using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Services;
using DeepEqual.Syntax;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using System.Security.Claims;
using System.Security.Principal;

namespace xUnit_Tests.car_tests.service
{
    public class ServiceTest
    {
        [Fact]
        public async void GetAllCarsTest_ReturnsListOfCars()
        {
            // Arrange
            var mockRepo = new Mock<ICarRepo>();
            var carList = GetCarsList();
            mockRepo.Setup(x => x.GetCars()).ReturnsAsync(carList);
            var carService = new CarService(mockRepo.Object);

            // Act
            var result = await carService.GetCars();

            // Assert
            Assert.NotNull(result);
            Assert.True(carList.IsDeepEqual(result));

        }

        [Fact]
        public async void CreateNewCarTest_ReturnsSuccess()
        {
            // Arrange
            int userId = 1;
            var mockRepo = new Mock<ICarRepo>();
            var carReq = GetTestCarRequest();
            mockRepo.Setup(x => x.PostCar(It.IsAny<Car>())).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object);

            // Act
            var result = await carService.CreateCar(userId, carReq);
            var okResult = result as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }


        [Fact]
        public async void GetCarByIdTest_ReturnsCarWithTheSameId()
        {
            // Arrange 
            int id = 1;
            var mockRepo = new Mock<ICarRepo>();
            var car = GetTestCar();
            mockRepo.Setup(x => x.GetCar(id)).ReturnsAsync(car);
            var carService = new CarService(mockRepo.Object);

            // Act 
            var result = await carService.GetCar(id);

            // Assert
            Assert.NotNull(result);
            Assert.True(car.IsDeepEqual(result.Value));
        }

        [Fact]
        public async void UpdateCarTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1;
            var mockRepo = new Mock<ICarRepo>();
            var car = GetTestCar();
            var carReq = GetTestCarRequest();
            mockRepo.Setup(x => x.GetCar(car.Id)).ReturnsAsync(car);
            mockRepo.Setup(x => x.PutCar(car.Id, car)).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object);


            // Act
            var result = await carService.UpdateCar(userId, car.Id, carReq);
            var ok = result as StatusCodeResult;

            // Assert
            Assert.NotNull(ok);
            Assert.Equal(200, ok.StatusCode);
        }

        [Fact]
        public async void DeleteCarTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1;
            var mockRepo = new Mock<ICarRepo>();
            var car = GetTestCar();
            mockRepo.Setup(x => x.GetCar(car.Id)).ReturnsAsync(car);
            mockRepo.Setup(x => x.DeleteCar(car)).ReturnsAsync(new StatusCodeResult(200));
            var carService = new CarService(mockRepo.Object);


            // Act
            var result = await carService.DeleteCar(userId, car.Id);
            var okResult = result as StatusCodeResult;


            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }

        private Car GetTestCar()
        {
            return new Car
            {
                Id = 1,
                Brand = "Toyota",
                Model = "Corolla",
                Year = 2019,
                Price = 100,
                SeatsCount = 5,
                Transmission = "manual",
                FuelType = "gasoline",
                BodyType = "sedan",
                HasAirConditioning = true,
                HasAbs = true,
                HasRadio = true,
                HasSunroof = false,
                Period = 5,
                Description = "A nice car",
                Longitude = 20,
                Latitude = 20,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                OwnerId = 1
            };
        }

        private CarRequest GetTestCarRequest()
        {
            return new CarRequest
                (
                  "Toyota", "Corolla", 2019, 100, 5, "manual", "gasoline",
                  "sedan", true, true, true, false, 5, "A nice car", 20, 20
                );
        }

        private ControllerContext GetTestIdentity()
        {
            var identity = new GenericIdentity("1", "1");
            var contextUser = new ClaimsPrincipal(identity);
            var httpContext = new DefaultHttpContext()
            {
                User = contextUser,
            };

            var controllerContext = new ControllerContext()
            {
                HttpContext = httpContext,
            };
            return controllerContext;
        }

        private ActionResult<IEnumerable<Car>> GetCarsList()
        {
            List<Car> CarsList = new List<Car>()
            {
                 GetTestCar(),
                 GetTestCar(),
                 GetTestCar()
            };
            return CarsList;
        }
}
}
