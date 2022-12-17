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
using Newtonsoft.Json;
using System.Diagnostics;

namespace xUnit_Tests.Car_Tests.Repo_Tests
{
    public class RepoTest
    {
        private readonly static DbContextOptions<TawsilaContext> options;
        private static Car[] Cars = {
            new Car{Id = 3, Brand = "tesla", Model = "v2",Year = 2020,Price = 100000,SeatsCount = 4,Transmission = "automatic",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = false,HasSunroof = true,Period = 5,Description = "fast car",Longitude = 25,Latitude = 25,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 2},
            new Car{Id = 4, Brand = "hundai", Model = "v3",Year = 2021,Price = 50000,SeatsCount = 4,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 28,Latitude = 6,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 2},
            new Car{Id = 5, Brand = "lanser", Model = "v4",Year = 2017,Price = 250000,SeatsCount = 4,Transmission = "automatic",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 31,Latitude = 5,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 3},
            new Car{Id = 6, Brand = "skoda", Model = "v5",Year = 2021,Price = 80000,SeatsCount = 4,Transmission = "manual",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 34,Latitude =43,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 4},
            new Car{Id = 7, Brand = "kia", Model = "v6",Year = 2022,Price = 120000,SeatsCount = 4,Transmission = "automatic",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = true,Period = 5,Description = "fast car",Longitude = 40,Latitude = 42,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 4},
        };




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
            foreach(Car car in Cars)
            {
                context.Cars.Add(car);
            }

            context.SaveChanges();
        }

        [Theory, Order(1)]
        [MemberData(nameof(testData))]
        public void GetCarsTestReturn_FilteredListOfCars(IEnumerable<Car> carsExpected, GetCarRequest carRequest)
        {
            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);

            IEnumerable<Car> cars = carRepo.GetCarsFiltered(carRequest).Result;
            Debug.WriteLine("iam here : " + cars.ToList().Count());

            Assert.NotNull(cars);
            var carsExpectedStr = JsonConvert.SerializeObject(carsExpected);
            var carsStr = JsonConvert.SerializeObject(cars);
            Assert.Equal(carsExpectedStr, carsStr);
        }
        [Order(1)]
        public static IEnumerable<object[]> testData()
        {
            IEnumerable<Car> carsExpected = new Car[] { new Car { Id = 3, Brand = "tesla", Model = "v2", Year = 2020, Price = 100000, SeatsCount = 4, Transmission = "automatic", FuelType = "benzene", BodyType = "sedan", HasAirConditioning = true, HasAbs = true, HasRadio = false, HasSunroof = true, Period = 5, Description = "fast car", Longitude = 25, Latitude = 25, CreatedAt = DateTime.MinValue, UpdatedAt = DateTime.MinValue, OwnerId = 2 } };
            CarFilterCriteria CFC = new("tesla", "", "", "", "", "", "", "Air Conditioning,Sun Roof,has abs", 25 , 25);

            GetCarRequest carRequest = new(CFC, 0, 0, 0);
            yield return new object[] { carsExpected, carRequest };

            carsExpected = new Car[] { };
            CFC = new("dlsfsfds", "", "", "", "", "", "", "Air Conditioning,Sun Roof,has abs", 25, 25);

            carRequest = new(CFC, 0, 0, 0);
            yield return new object[] { carsExpected, carRequest };


            carsExpected = new Car[] {
                new Car{Id = 3, Brand = "tesla", Model = "v2",Year = 2020,Price = 100000,SeatsCount = 4,Transmission = "automatic",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = false,HasSunroof = true,Period = 5,Description = "fast car",Longitude = 25,Latitude = 25,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 2, distanceFromUser = 0},
                new Car{Id = 1,Brand = "Toyota",Model = "Corolla",Year = 2019,Price = 100,SeatsCount = 5,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "A nice car",Longitude = 20,Latitude = 20,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 1, distanceFromUser = 30},
                new Car{Id = 2,Brand = "Toyota",Model = "Corolla",Year = 2019,Price = 100,SeatsCount = 5,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "A nice car",Longitude = 20,Latitude = 20,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 1, distanceFromUser = 30},
                new Car{Id = 7, Brand = "kia", Model = "v6",Year = 2022,Price = 120000,SeatsCount = 4,Transmission = "automatic",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = true,Period = 5,Description = "fast car",Longitude = 40,Latitude = 42,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 4, distanceFromUser = 304},
                new Car{Id = 6, Brand = "skoda", Model = "v5",Year = 2021,Price = 80000,SeatsCount = 4,Transmission = "manual",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 34,Latitude =43,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 4, distanceFromUser = 333},
                new Car{Id = 4, Brand = "hundai", Model = "v3",Year = 2021,Price = 50000,SeatsCount = 4,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 28,Latitude = 6,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 2, distanceFromUser = 364},
                new Car{Id = 5, Brand = "lanser", Model = "v4",Year = 2017,Price = 250000,SeatsCount = 4,Transmission = "automatic",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 31,Latitude = 5,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 3, distanceFromUser = 406},
            };
            CFC = new("", "", "", "", "", "", "", "", 25, 25);
            carRequest = new(CFC, 0, 0, 0);
            yield return new object[] { carsExpected, carRequest };

            carsExpected = new Car[] {
                new Car{Id = 1,Brand = "Toyota",Model = "Corolla",Year = 2019,Price = 100,SeatsCount = 5,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "A nice car",Longitude = 20,Latitude = 20,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 1, distanceFromUser = 30},
                new Car{Id = 2,Brand = "Toyota",Model = "Corolla",Year = 2019,Price = 100,SeatsCount = 5,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "A nice car",Longitude = 20,Latitude = 20,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 1 , distanceFromUser = 30},
                new Car{Id = 6, Brand = "skoda", Model = "v5",Year = 2021,Price = 80000,SeatsCount = 4,Transmission = "manual",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 34,Latitude =43,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 4, distanceFromUser = 333},
                new Car{Id = 4, Brand = "hundai", Model = "v3",Year = 2021,Price = 50000,SeatsCount = 4,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 28,Latitude = 6,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 2 , distanceFromUser = 364},
                new Car{Id = 5, Brand = "lanser", Model = "v4",Year = 2017,Price = 250000,SeatsCount = 4,Transmission = "automatic",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 31,Latitude = 5,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 3, distanceFromUser = 406},
            };
            CFC = new("", "", "2016,2023", "", "", "", "", "Air Conditioning,has abs,Radio", 25, 25);
            carRequest = new(CFC, 0, 0, 0);
            yield return new object[] { carsExpected, carRequest };
            //yield return new object[] { };
            //yield return new object[] { };
        }


        [Fact, Order(2)]

        public void GetAllCarsTest_ReturnsListOfCars()
        {

            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);

            ActionResult<IEnumerable<Car>> cars = carRepo.GetCars().Result;

            Assert.NotNull(cars.Value);
            Assert.Equal(7, cars.Value.Count());
        }


        [Fact, Order(3)]
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

        [Fact, Order(4)]
        public void PostCarTest_ReturnsSuccess()
        {
            Car car = GetTestCar(8);
            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);
            var res = carRepo.PostCar(car).Result;
            var okResult = res as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(200, okResult.StatusCode);
        }

        [Fact, Order(5)]
        public void PutCarTest_ReturnsSuccess()
        {
            var car = GetTestCar(8);
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
            var car = GetTestCar(15);
            using var context = new TawsilaContext(options);
            CarRepo carRepo = new(context);
            var res = carRepo.PutCar(car.Id, car).Result;
            var okResult = res as StatusCodeResult;

            // Assert
            Assert.NotNull(okResult);
            Assert.Equal(404, okResult.StatusCode);
        }

        [Fact, Order(6)]

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
                CreatedAt = DateTime.MinValue,
                UpdatedAt = DateTime.MinValue,
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
