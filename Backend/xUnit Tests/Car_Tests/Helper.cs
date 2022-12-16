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
