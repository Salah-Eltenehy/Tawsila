using Backend.Contexts;
using Backend.Models.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Backend.Repositories
{
    public class CarRepo
    {
        private readonly TawsilaContext _context;

        public CarRepo(TawsilaContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<IEnumerable<Car>>> GetCars()
        {
            return await _context.Cars.ToListAsync();
        }

        public async Task<Car> GetCar(int id)
        {
            var car =  await _context.Cars.FindAsync(id);
            return car;
        }

        public async Task PostCar(Car car)
        {
            _context.Cars.Add(car);
            await _context.SaveChangesAsync();
        }

        public async Task<Car> PutCar(int id, Car car)
        {

            _context.Entry(car).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CarExists(id))
                {
                    return car;
                }
                else
                {
                    throw;
                }
            }

            return car;
        }


        public async Task DeleteCar(Car car)
        {
            _context.Cars.Remove(car);
            await _context.SaveChangesAsync();
        }

        public bool CarExists(int id)
        {
            return _context.Cars.Any(e => e.Id == id);
        }
    }
}
