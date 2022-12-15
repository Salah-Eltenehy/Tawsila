using Backend.Contexts;
using Backend.Models.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Server.IIS.Core;
using Microsoft.EntityFrameworkCore;

public interface ICarRepo
{
    public   Task<ActionResult<IEnumerable<Car>>> GetCars();
    public   Task<ActionResult<Car>> GetCar(int id);
    public  Task<ActionResult> PostCar(Car car);
    public Task<ActionResult> PutCar(int id, Car car);
    public  Task<ActionResult> DeleteCar(Car car);
}


namespace Backend.Repositories
{
    public class CarRepo: ICarRepo
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

        public async Task<ActionResult<Car>> GetCar(int id)
        {
            try
            {
                var car = await _context.Cars.FindAsync(id);
                return car;
            }catch (Exception e)
            {
                return new StatusCodeResult(500);
            }
        }

        public async Task<ActionResult> PostCar(Car car)
        {
            try
            {
                _context.Cars.Add(car);
                await _context.SaveChangesAsync();
               
            }catch (Exception e)
            {
                return new StatusCodeResult(500);
            }
            return new StatusCodeResult(200);
            
        }

        public async Task<ActionResult> PutCar(int id, Car car)
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
                    return new StatusCodeResult(404);
                }
                else
                {
                    throw;
                }
            }
            return new StatusCodeResult(200);
        }


        public async Task<ActionResult> DeleteCar(Car car)
        {
            try
            {
                _context.Cars.Remove(car);
                await _context.SaveChangesAsync();
            }catch(Exception e)
            {
                return new StatusCodeResult(500);
            }
            return new StatusCodeResult(200);
        }

        public bool CarExists(int id)
        {
            return _context.Cars.Any(e => e.Id == id);
        }
    }
}
