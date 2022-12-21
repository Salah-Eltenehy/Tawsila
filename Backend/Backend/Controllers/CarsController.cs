using Microsoft.AspNetCore.Mvc;
using Backend.Models.API.CarAPI;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using Backend.Models.API;
using Backend.Services;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.Extensions.Logging;

namespace Backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class CarsController : ControllerBase
    {
        private readonly ICarService _carService;
        private readonly ILogger<UsersController> _logger;

        public CarsController(ICarService carService, ILogger<UsersController> logger)
        {
            _logger = logger;
            _carService = carService;
        }

        [HttpGet]
        [Authorize(Policy = "VerifiedUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCars([FromQuery] GetCarsRequest req)
        {
            var carsPaginatedList = await _carService.GetCars(req);
            var carItems = carsPaginatedList.Items
                .Select(
                    car =>
                        new CarItem(
                            car.Id,
                            car.Brand,
                            car.Model,
                            car.Year,
                            car.SeatsCount,
                            car.HasAirConditioning,
                            car.Price,
                            car.Images[0],
                            car.UpdatedAt
                        )
                )
                .ToArray();
            var totalCount = carsPaginatedList.TotalCount;
            var offset = carsPaginatedList.Offset;
            return Ok(new GetCarsResponse(carItems, totalCount, offset));
        }

        [HttpGet("{id}")]
        [Authorize(Policy = "VerifiedUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCar([FromRoute] int id)
        {
            var car = await _carService.GetCar(id);
            var res = new GetCarResponse(
                car.Id,
                car.Brand,
                car.Model,
                car.Year,
                car.Price,
                car.SeatsCount,
                car.Transmission,
                car.FuelType,
                car.BodyType,
                car.HasAirConditioning,
                car.HasAbs,
                car.HasRadio,
                car.HasSunroof,
                car.Period,
                car.Description,
                car.Images,
                car.Longitude,
                car.Latitude,
                car.UpdatedAt,
                car.OwnerId
            );
            return Ok(res);
        }

        [HttpPost]
        [Authorize(Policy = "VerifiedUser")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> CreateCar([FromBody] CreateCarRequest req)
        {
            var claims = HttpContext.User.Claims;
            var UserId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
            await _carService.CreateCar(UserId, req);
            return Ok(new GenericResponse("Car created successfully"));
        }

        [HttpPut("{id}")]
        [Authorize(Policy = "VerifiedUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateCar([FromRoute] int id, [FromBody] UpdateCarRequest req)
        {
            var claims = HttpContext.User.Claims.ToArray();
            var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
            await _carService.UpdateCar(claimedId, id, req);
            return Ok(new GenericResponse("Car updated successfully"));
        }

        [HttpDelete("{id}")]
        [Authorize(Policy = "VerifiedUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteCar([FromRoute] int id)
        {
            var claims = HttpContext.User.Claims.ToArray();
            var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
            await _carService.DeleteCar(claimedId, id);
            return Ok(new GenericResponse("Car deleted successfully"));
        }
    }
}
