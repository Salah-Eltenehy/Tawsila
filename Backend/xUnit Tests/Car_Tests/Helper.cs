using Backend.Models.API.CarAPI;
using Backend.Models.Entities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace xUnit_Tests.Car_Tests
{
    public class Helper
    {
        public static Car GetTestCar(int id)
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

        public static IEnumerable<Car> GetFilteredCarsList()
        {
            return new Car[] {
                new Car{Id = 3, Brand = "tesla", Model = "v2",Year = 2020,Price = 100000,SeatsCount = 4,Transmission = "automatic",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = false,HasSunroof = true,Period = 5,Description = "fast car",Longitude = 25,Latitude = 25,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 2, distanceFromUser = 0},
                new Car{Id = 1,Brand = "Toyota",Model = "Corolla",Year = 2019,Price = 100,SeatsCount = 5,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "A nice car",Longitude = 20,Latitude = 20,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 1, distanceFromUser = 30},
                new Car{Id = 2,Brand = "Toyota",Model = "Corolla",Year = 2019,Price = 100,SeatsCount = 5,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "A nice car",Longitude = 20,Latitude = 20,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 1, distanceFromUser = 30},
                new Car{Id = 7, Brand = "kia", Model = "v6",Year = 2022,Price = 120000,SeatsCount = 4,Transmission = "automatic",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = true,Period = 5,Description = "fast car",Longitude = 40,Latitude = 42,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 4, distanceFromUser = 304},
                new Car{Id = 6, Brand = "skoda", Model = "v5",Year = 2021,Price = 80000,SeatsCount = 4,Transmission = "manual",FuelType = "benzene",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 34,Latitude =43,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 4, distanceFromUser = 333},
                new Car{Id = 4, Brand = "hundai", Model = "v3",Year = 2021,Price = 50000,SeatsCount = 4,Transmission = "manual",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 28,Latitude = 6,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 2, distanceFromUser = 364},
                new Car{Id = 5, Brand = "lanser", Model = "v4",Year = 2017,Price = 250000,SeatsCount = 4,Transmission = "automatic",FuelType = "gasoline",BodyType = "sedan",HasAirConditioning = true,HasAbs = true,HasRadio = true,HasSunroof = false,Period = 5,Description = "fast car",Longitude = 31,Latitude = 5,CreatedAt = DateTime.MinValue,UpdatedAt = DateTime.MinValue,OwnerId = 3, distanceFromUser = 406},
            };
        }

        public static IEnumerable<Car> GetEmptyCarsList()
        {
            return new Car[] {};
        }

        public static CarRequest GetTestCarRequest()
        {
            return new CarRequest
                (
                    "Toyota", "Corolla", 2019, 100, 5, "manual", "gasoline",
                    "sedan", true, true, true, false, 5, "A nice car", 20, 20
                );
        }

        public static ControllerContext GetTestIdentity()
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

        public static ActionResult<IEnumerable<Car>> GetCarsList()
        {
            List<Car> CarsList = new()
            {
                GetTestCar(1),
                GetTestCar(2),
                GetTestCar(3)
            };
            return CarsList;
        }


    }
}
