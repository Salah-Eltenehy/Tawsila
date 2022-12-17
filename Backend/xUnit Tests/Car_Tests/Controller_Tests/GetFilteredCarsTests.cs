using Backend.Controllers;
using Backend.Models.API.CarAPI;
using Backend.Models.Entities;
using Moq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit.Extensions.Ordering;

namespace xUnit_Tests.Car_Tests.Controller_Tests
{
    public class GetFilteredCarsTests
    {

        [Theory]
        [MemberData(nameof(testData))]
        public void GetCarsTestReturn_FilteredListOfCars(IEnumerable<Car> carsExpected, GetCarRequest carRequest)
        {
            // Arrange
            var controllerContext = Helper.GetTestIdentity();
            var mockService = new Mock<ICarService>();
            //var carList = Helper.GetFilteredCarsList();
            mockService.Setup(x => x.GetFilteredCars(carRequest)).ReturnsAsync(carsExpected);
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            IEnumerable<Car> cars = carController.GetFilteredCars(carRequest).Result;
            Debug.WriteLine("iam here : " + cars.ToList().Count());

            Assert.NotNull(cars);
            var carsExpectedStr = JsonConvert.SerializeObject(carsExpected);
            var carsStr = JsonConvert.SerializeObject(cars);
            Assert.Equal(carsExpectedStr, carsStr);
        }

        public static IEnumerable<object[]> testData()
        {
            IEnumerable<Car> carsExpected = new Car[] { new Car { Id = 3, Brand = "tesla", Model = "v2", Year = 2020, Price = 100000, SeatsCount = 4, Transmission = "automatic", FuelType = "benzene", BodyType = "sedan", HasAirConditioning = true, HasAbs = true, HasRadio = false, HasSunroof = true, Period = 5, Description = "fast car", Longitude = 25, Latitude = 25, CreatedAt = DateTime.MinValue, UpdatedAt = DateTime.MinValue, OwnerId = 2 } };
            CarFilterCriteria CFC = new("tesla", "", "", "", "", "", "", "Air Conditioning,Sun Roof,has abs", 25, 25);

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
        }
    }
}
