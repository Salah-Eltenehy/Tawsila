using Backend.Controllers;
using Backend.Models.API.CarAPI;
using Backend.Models.Entities;
using DeepEqual.Syntax;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Security.Principal;

namespace xUnit_Tests.car_tests.controller
{
    public class CarControllerTest
    {
       
        [Fact]
        public async void GetAllCarsTest_ReturnsListOfCars()
        {
            // Arrange
            var controllerContext = GetTestIdentity();
            var mockService = new Mock<ICarService>();
            var carList = GetCarsList();
            mockService.Setup(x => x.GetCars()).ReturnsAsync(carList);
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await carController.GetCars();

            // Assert
            Assert.NotNull(result);
            Assert.True(carList.IsDeepEqual(result));

        }

        [Fact]
        public async void CreateNewCarTest_ReturnsSuccess()
        {
            // Arrange
            var controllerContext = GetTestIdentity(); 
            var mockService = new Mock<ICarService>();
            var carReq = GetTestCarRequest();
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
        public async void GetCarByIdTest_ReturnsCarWithTheSameId()
        {
            // Arrange 
            int id = 1;
            var mockService = new Mock<ICarService>();
            var car = GetTestCar();
            mockService.Setup(x => x.GetCar(id)).ReturnsAsync(car);
            var carController = new CarsController(mockService.Object);
            
            // Act 
            var result = await carController.GetCar(id);

            // Assert
            Assert.NotNull(result);
            Assert.True(car.IsDeepEqual(result.Value));
        }

        [Fact]
        public async void UpdateCarTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1, carId = 1;
            var controllerContext = GetTestIdentity();
            var mockService = new Mock<ICarService>();
            var carRequest = GetTestCarRequest();
            var updatedCar = GetTestCar();
            mockService.Setup(x => x.UpdateCar(userId, carId, It.IsAny<CarRequest>())).ReturnsAsync(new StatusCodeResult(200));
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await carController.UpdateCar(1, carRequest);

            var k = result as StatusCodeResult;

            // Assert
            Assert.NotNull(k);
            Assert.Equal(200, k.StatusCode);
        }

        [Fact]
        public async void DeleteCarTest_ReturnsSuccess()
        {
            // Arrange 
            int userId = 1, carId = 1;
            var controllerContext = GetTestIdentity();
            var mockService = new Mock<ICarService>();
            var carRequest = GetTestCarRequest();
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