using Backend.Models;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Services
{
    public class CarService : ICarService
    {
        public Task<IActionResult> CreateCar(int id, Car car)
        {
            throw new NotImplementedException();
        }

        public Task<IActionResult> DeleteCar(int id)
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<Car>> GetCar(int id)
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<IEnumerable<Car>>> GetCars()
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<Car>> UpdateCar(Car car)
        {
            throw new NotImplementedException();
        }
    }
}
