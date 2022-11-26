using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Backend.Services
{
    public interface ICarService
    {
        
        public Task<ActionResult<IEnumerable<Car>>> GetCars();
        public  Task<ActionResult<Car>> GetCar(int id);
        public Task<IActionResult> CreateCar(int id, Car car);
        public Task<ActionResult<Car>> UpdateCar(Car car);
        public Task<IActionResult> DeleteCar(int id);

    }
}
