using Backend.Models.Entities;
using Microsoft.AspNetCore.Mvc;

public interface ICarService
{

    public Task<ActionResult<IEnumerable<Car>>> GetCars();
    public Task<ActionResult<Car>> GetCar(int id);
    public Task<IActionResult> CreateCar(int id, Car car);
    public Task<ActionResult<Car>> UpdateCar(Car car);
    public Task<IActionResult> DeleteCar(int id);

}

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
