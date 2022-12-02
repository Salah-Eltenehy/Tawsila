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

namespace Backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class CarsController : ControllerBase
    {

        private readonly CarRepo _carRepo;
        public CarsController(CarRepo carRepo)
        {
            _carRepo = carRepo;

        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Car>>> GetCars()
        {
            return await _carRepo.GetCars();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Car>> GetCar(int id)
        {
            var car = await _carRepo.GetCar(id);

            if (car == null)
            {
                return NotFound();
            }

            return car;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutCar(int id, Car car)
        {
            if (id != car.Id)
            {
                return BadRequest();
            }

            await _carRepo.PutCar(id, car);

            return NoContent();
        }

        [HttpPost]
        public async Task<ActionResult<Car>> PostCar(Car car)
        {
            await _carRepo.PostCar(car);
            return CreatedAtAction("GetCar", new { id = car.Id }, car);
        }


        [HttpDelete("{id}")]
        public async Task<Car> DeleteCar(int id)
        {
            return await _carRepo.DeleteCar(id);
        }

        
    }
}
