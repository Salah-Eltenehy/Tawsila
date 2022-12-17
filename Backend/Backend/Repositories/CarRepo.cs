using Backend.Contexts;
using Backend.Models.API.CarAPI;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
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
    Task<IEnumerable<Car>> GetCarsFiltered(GetCarRequest carReq);
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
                if(car == null)
                {
                    throw new NotFoundException("Car not found");
                }
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
            }catch(Exception e)
            {
                return new StatusCodeResult(500);
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

        public async Task<IEnumerable<Car>> GetCarsFiltered(GetCarRequest carRequest)
        {
            CarFilterCriteria CFC = carRequest.criteria;
            /*string[] brands = CFC.brand.Split(",");
            string[] model = CFC.model.Split(",");
            string[] year = CFC.year.Split(",");
            string[] price = CFC.price.Split(",");
            string[] transmision = CFC.transmission.Split(",");
            string[] feulType = CFC.fuelType.Split(",");
            string[] bodyType = CFC.bodyType.Split(",");
            string[] options = CFC.options.Split(",");*/

            string brands = CFC.brand;
            string model = CFC.model;
            string yearS = CFC.year;
            string priceS = CFC.price;
            string transmision = CFC.transmission;
            string feulType = CFC.fuelType;
            string bodyType = CFC.bodyType;
            string[] options = CFC.options.Split(",");
            bool hasAirConditioning = false;
            bool hasAbs = false;
            bool hasRadio = false;
            bool hasSunroof = false;

            int yearBegin = 0;
            int priceBegin = 0;

            int yearEnd = 2023;
            long priceEnd = 10000000000;

            if (yearS.Length > 0)
            {
                yearBegin = int.Parse(yearS.Split(",")[0]);
                yearEnd = int.Parse(yearS.Split(",")[1]);
            }
            if (priceS.Length > 0)
            {
                priceBegin = int.Parse(priceS.Split(",")[0]);
                priceEnd = int.Parse(priceS.Split(",")[1]);
            }

            foreach (string option in options)
            {
                if (option == "Sun Roof") hasSunroof =true;
                else if (option == "has abs") hasAbs = true;
                else if (option == "Air Conditioning") hasAirConditioning = true;
                else if (option == "Radio") hasRadio = true;
            }

         

            IEnumerable<Car> cars = new List<Car>();
            int total_count = carRequest.total_count;
            int offset = carRequest.offset;
            int updatedOffset = carRequest.updatedOffset;

            if (brands.Length == 0 && model.Length == 0 && yearS.Length == 0 && priceS.Length == 0 && transmision.Length == 0 && feulType.Length == 0 && bodyType.Length == 0 && CFC.options.Length == 0)
            {
                cars = _context.Cars.Where(c => c.Brand.Contains(brands))
                    .Where(c => c.Model.Contains(model))
                    .Where(c => c.Transmission.Contains(transmision))
                    .Where(c => c.FuelType.Contains(feulType))
                    .Where(c => c.BodyType.Contains(bodyType))
                    .Where(c => c.Year > yearBegin)
                    .Where(c => c.Year < yearEnd)
                    .Where(c => c.Price > priceBegin)
                    .Where(c => c.Price < priceEnd);
            }
            else
            {
                cars = _context.Cars.Where(c => c.Brand.Contains(brands))
                    .Where(c => c.Model.Contains(model))
                    .Where(c => c.Transmission.Contains(transmision))
                    .Where(c => c.FuelType.Contains(feulType))
                    .Where(c => c.BodyType.Contains(bodyType))
                    .Where(c => c.Year > yearBegin)
                    .Where(c => c.Year < yearEnd)
                    .Where(c => c.Price > priceBegin)
                    .Where(c => c.Price < priceEnd)
                    .Where(c => c.HasAirConditioning == hasAirConditioning)
                    .Where(c => c.HasAbs == hasAbs)
                    .Where(c => c.HasRadio == hasRadio)
                    .Where(c => c.HasSunroof == hasSunroof);
            }



            Console.WriteLine("iam here : " + cars.ToList().Count());

            return cars;


            //return new StatusCodeResult(500);
            //return new StatusCodeResult(200);
        }

        public async Task<IEnumerable<Review>> GetReviews(int id, int offset, int limit)
        {
            return await _context.Reviews.Where(r => r.RevieweeId == id).Skip(offset).Take(limit).ToListAsync();
        }

        public bool CarExists(int id)
        {
            return _context.Cars.Any(e => e.Id == id);
        }
    }
}
