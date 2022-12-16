using Microsoft.EntityFrameworkCore;
using Backend.Models.Entities;
using Backend.Models.API.CarAPI;
using Microsoft.AspNetCore.Mvc;
using Backend.Repositories;
using Backend.Contexts;
using System.Collections.Generic;
using DeepEqual.Syntax;
using Xunit;
using Xunit.Extensions.Ordering;

namespace xUnit_Tests.Car_Tests.Repo_Tests
{
    public class RepoTest
    {
        private readonly static DbContextOptions<TawsilaContext> options;
        static RepoTest()
        {
            options = new DbContextOptionsBuilder<TawsilaContext>()
           .UseInMemoryDatabase(databaseName: "Tawsila")
           .Options;

            using var context = new TawsilaContext(options);
            Car car1 = GetTestCar(1);
            Car car2 = GetTestCar(2);
            context.Cars.Add(car1);
            context.Cars.Add(car2);
            context.SaveChanges();
        }

        [Fact, Order(1)]

        public void GetAllCarsTest_ReturnsListOfCars()
        {

            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);

            ActionResult<IEnumerable<Car>> cars = carRepo.GetCars().Result;

            Assert.NotNull(cars.Value);
            Assert.Equal(2, cars.Value.Count());
        }

        [Fact, Order(2)]
        public void GetCarById_ReturnsCarNotNull()
        {
            int carId = 1;
            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);
            var res = carRepo.GetCar(carId).Result;

            Assert.NotNull(res);
            Assert.NotNull(res.Value);
            Car car = res.Value;
            Assert.NotNull(car);
            Assert.Equal(carId, car.Id);

        }

        [Fact, Order(3)]
        public void PostCarTest_ReturnsSuccess()
        {
            Car car = GetTestCar(3);
            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);
            var res = carRepo.PostCar(car).Result;
            var okResult = res as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }

        [Fact, Order(4)]
        public void PutCarTest_ReturnsSuccess()
        {
            var car = GetTestCar(3);
            car.Brand = "Mercedes";
            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);
            var res = carRepo.PutCar(car.Id, car).Result;
            var okResult = res as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }

        [Fact]
        public void PutCarTest_Returns_404()
        {
            var car = GetTestCar(5);
            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);
            var res = carRepo.PutCar(car.Id, car).Result;
            var okResult = res as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(404, okResult.StatusCode);
        }

        [Fact, Order(5)]

        public void DeleteCarTest_ReturnsSuccess()
        {
            Car car = GetTestCar(2);
            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);
            var res = carRepo.DeleteCar(car).Result;
            var okResult = res as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }








        private static Car GetTestCar(int id)
        {
            return new Car
            {
                Id = id,
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

        private ActionResult<IEnumerable<Car>> GetCarsList()
        {
            List<Car> CarsList = new List<Car>()
            {
                 GetTestCar(1),
                 GetTestCar(2),
                 GetTestCar(3)
            };
            return CarsList;
        }
    }
}
