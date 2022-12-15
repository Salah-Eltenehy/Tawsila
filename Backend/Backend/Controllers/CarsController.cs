using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Contexts;
using Backend.Models;
using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Models.API.CarAPI;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using Backend.Models.API;

namespace Backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class CarsController : ControllerBase
    {

        private readonly ICarService _carService;

        public CarsController(ICarService carService)
        {
            _carService = carService;
        }

        [HttpGet]
        [Authorize(Policy = "VerifiedUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<IEnumerable<Car>>> GetCars()
        {
            return await _carService.GetCars();
        }

        [HttpGet("{id}")]
        [Authorize(Policy = "VerifiedUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<Car>> GetCar([FromRoute] int id)
        {
            var car = await _carService.GetCar(id);

            if (car == null)
            {
                return NotFound();
            }

            return car;
        }

        [HttpPost]
        [Authorize(Policy = "VerifiedUser")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> CreateNewCar([FromBody] CarRequest carReq)
        {

            var claims =  HttpContext.User.Claims;
            var UserId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
            await _carService.CreateCar(UserId, carReq);
            return Ok("Car Created Successfully");
        }


        [HttpPut("{id}")]
        [Authorize(Policy = "VerifiedUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateCar([FromRoute] int id, [FromBody] CarRequest carReq)
        {
            var claims = HttpContext.User.Claims.ToArray();
            var claimedId = int.Parse(claims.First(c => c.Type == ClaimTypes.Name).Value);
            var car = await _carService.UpdateCar(claimedId, id ,carReq);
            if(car == null)
            {
                return Unauthorized("You can only update your cars");
            }
            return Ok("Car Updated Successfully");
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
            return Ok("Car Deleted Successfully");
        }
    }
}
