using Backend.Contexts;
using Backend.Models;
using Backend.Models.API.CarAPI;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Microsoft.EntityFrameworkCore;

namespace Backend.Repositories;

public interface ICarRepo
{
    public Task<Car> GetCar(int id);
    public Task<PaginatedList<Car>> GetCars(GetCarsRequest req);
    public Task<Car> CreateCar(Car car);
    public Task<Car> UpdateCar(int id, UpdateCarRequest update);
    public Task DeleteCar(int id);
}

public class CarRepo : ICarRepo
{
    private readonly TawsilaContext _context;

    public CarRepo(TawsilaContext context)
    {
        _context = context;
    }

    public async Task<Car> GetCar(int id)
    {
        var car = await _context.Cars.FindAsync(id);
        if (car == null)
        {
            throw new NotFoundException("Car not found");
        }

        _context.Entry(car).State = EntityState.Detached;
        return car;
    }

    public async Task<PaginatedList<Car>> GetCars(GetCarsRequest req)
    {
        string[] brands = req.Brands != null 
            ? req.Brands.Split(",", StringSplitOptions.RemoveEmptyEntries)
            : Array.Empty<string>();
        string[] models = req.Models != null
            ? req.Models.Split(",", StringSplitOptions.RemoveEmptyEntries)
            : Array.Empty<string>();
        int? minYear = req.MinYear;
        int? maxYear = req.MaxYear;
        int? minPrice = req.MinPrice;
        int? maxPrice = req.MaxPrice;
        int? seatsCount = req.SeatsCount;
        string[] Transmission = req.Transmission != null
            ? req.Transmission.Split(",", StringSplitOptions.RemoveEmptyEntries)
            : Array.Empty<string>();
        string[] fuelTypes = req.FuelTypes != null
            ? req.FuelTypes.Split(",", StringSplitOptions.RemoveEmptyEntries)
            : Array.Empty<string>();
        string[] bodyTypes = req.BodyTypes != null
            ? req.BodyTypes.Split(",", StringSplitOptions.RemoveEmptyEntries)
            : Array.Empty<string>();
        bool? hasAirConditioning = req.HasAirConditioning;
        bool? hasAbs = req.HasAbs;
        bool? hasRadio = req.HasRadio;
        bool? hasSunroof = req.HasSunroof;
        double longitude = req.Longitude;
        double latitude = req.Latitude;
        string sortBy = req.SortBy ?? "PRICE_DESC";
        int? offset = req.Offset;

        if (minYear < 1901)
        {
            throw new BadRequestException("Minimum year cannot be less than 1901");
        }

        if (maxYear < 1901)
        {
            throw new BadRequestException("Maximum year cannot be less than 1901");
        }

        if (minPrice < 50)
        {
            throw new BadRequestException("Minimum price cannot be less than 50");
        }

        if (maxPrice < 50)
        {
            throw new BadRequestException("Maximum price cannot be less than 50");
        }

        if (seatsCount < 1)
        {
            throw new BadRequestException("Seats count cannot be less than 1");
        }

        if (longitude < -180 || longitude > 180)
        {
            throw new BadRequestException("Longitude must be between -180 and 180");
        }

        if (latitude < -90 || latitude > 90)
        {
            throw new BadRequestException("Latitude must be between -90 and 90");
        }

        if (
            !(
                sortBy == "PRICE_ASC"
                || sortBy == "PRICE_DESC"
                || sortBy == "YEAR_DESC"
                || sortBy == "YEAR_ASC"
            )
        )
        {
            throw new BadRequestException(
                "SortBy must be one of the following: PRICE_ASC, PRICE_DESC, YEAR_DESC, YEAR_ASC"
            );
        }

        IQueryable<Car> cars = _context.Cars.AsNoTracking().Where(c => c.IsListed == true);

        if (brands.Length > 0)
        {
            cars = cars.Where(c => brands.Contains(c.Brand));
        }

        if (models.Length > 0)
        {
            cars = cars.Where(c => models.Contains(c.Model));
        }

        if (minYear != null)
        {
            cars = cars.Where(c => c.Year >= minYear);
        }

        if (maxYear != null)
        {
            cars = cars.Where(c => c.Year <= maxYear);
        }

        if (minPrice != null)
        {
            cars = cars.Where(c => c.Price >= minPrice);
        }

        if (maxPrice != null)
        {
            cars = cars.Where(c => c.Price <= maxPrice);
        }

        if (seatsCount != null)
        {
            cars = cars.Where(c => c.SeatsCount == seatsCount);
        }

        if (Transmission.Length > 0)
        {
            cars = cars.Where(c => Transmission.Contains(c.Transmission));
        }

        if (fuelTypes.Length > 0)
        {
            cars = cars.Where(c => fuelTypes.Contains(c.FuelType));
        }

        if (bodyTypes.Length > 0)
        {
            cars = cars.Where(c => bodyTypes.Contains(c.BodyType));
        }

        if (hasAirConditioning != null)
        {
            cars = cars.Where(c => c.HasAirConditioning == hasAirConditioning);
        }

        if (hasAbs != null)
        {
            cars = cars.Where(c => c.HasAbs == hasAbs);
        }

        if (hasRadio != null)
        {
            cars = cars.Where(c => c.HasRadio == hasRadio);
        }

        if (hasSunroof != null)
        {
            cars = cars.Where(c => c.HasSunroof == hasSunroof);
        }

        var nearCars = cars.Select(
                c =>
                    new
                    {
                        Car = c,
                        Distance = 3959 * Math.Acos(
                            Math.Cos(
                                Math.PI * latitude / 180
                            ) * Math.Cos(
                                Math.PI * c.Latitude / 180
                            ) * Math.Cos(
                                Math.PI * c.Longitude / 180 - Math.PI * longitude / 180
                            ) + Math.Sin(
                                Math.PI * latitude / 180
                            ) * Math.Sin(
                                Math.PI * c.Latitude / 180
                            )
                        )
                    }
            )
            .Where(c => c.Distance <= 4)
            .OrderBy(c => c.Distance);

        if (sortBy == "PRICE_ASC")
        {
            nearCars = nearCars.ThenBy(c => c.Car.Price);
        }
        else if (sortBy == "PRICE_DESC")
        {
            nearCars = nearCars.ThenByDescending(c => c.Car.Price);
        }
        else if (sortBy == "YEAR_DESC")
        {
            nearCars = nearCars.ThenByDescending(c => c.Car.Year);
        }
        else if (sortBy == "YEAR_ASC")
        {
            nearCars = nearCars.ThenBy(c => c.Car.Year);
        }

        return new PaginatedList<Car>(
            await nearCars.Select(c => c.Car).Skip(offset ?? 0).Take(10).ToArrayAsync(),
            await nearCars.CountAsync(),
            offset ?? 0
        );
    }

    public async Task<Car> CreateCar(Car car)
    {
        int price = car.Price;
        int year = car.Year;
        int seatsCount = car.SeatsCount;
        int period = car.Period;
        double longitude = car.Longitude;
        double latitude = car.Latitude;

        if (price < 50)
        {
            throw new BadRequestException("Price cannot be less than 50");
        }

        if (year < 1901)
        {
            throw new BadRequestException("Year cannot be less than 1901");
        }

        if (seatsCount < 1)
        {
            throw new BadRequestException("Seats count cannot be less than 1");
        }

        if (period < 1)
        {
            throw new BadRequestException("Period cannot be less than 1");
        }

        if (longitude < -180 || longitude > 180)
        {
            throw new BadRequestException("Longitude must be between -180 and 180");
        }

        if (latitude < -90 || latitude > 90)
        {
            throw new BadRequestException("Latitude must be between -90 and 90");
        }

        Car trackedCar = (Car) car.Clone();
        await _context.Cars.AddAsync(trackedCar);
        trackedCar.CreatedAt = DateTime.UtcNow;
        trackedCar.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        _context.Entry(trackedCar).State = EntityState.Detached;
        return trackedCar;
    }

    public async Task<Car> UpdateCar(int id, UpdateCarRequest update)
    {
        var car = await _context.Cars.FindAsync(id);
        if (car == null)
        {
            throw new NotFoundException("Car not found");
        }

        if (update.Price < 50)
        {
            throw new BadRequestException("Price cannot be less than 50");
        }

        if (update.Year < 1901)
        {
            throw new BadRequestException("Year cannot be less than 1901");
        }

        if (update.SeatsCount < 1)
        {
            throw new BadRequestException("Seats count cannot be less than 1");
        }

        if (update.Period < 1)
        {
            throw new BadRequestException("Period cannot be less than 1");
        }

        if (update.Longitude < -180 || update.Longitude > 180)
        {
            throw new BadRequestException("Longitude must be between -180 and 180");
        }

        if (update.Latitude < -90 || update.Latitude > 90)
        {
            throw new BadRequestException("Latitude must be between -90 and 90");
        }

        car.Brand = update.Brand;
        car.Model = update.Model;
        car.Year = update.Year;
        car.Price = update.Price;
        car.SeatsCount = update.SeatsCount;
        car.Transmission = update.Transmission;
        car.FuelType = update.FuelType;
        car.BodyType = update.BodyType;
        car.HasAirConditioning = update.HasAirConditioning;
        car.HasAbs = update.HasAbs;
        car.HasRadio = update.HasRadio;
        car.HasSunroof = update.HasSunroof;
        car.Period = update.Period;
        car.Description = update.Description;
        car.Longitude = update.Longitude;
        car.Latitude = update.Latitude;
        await _context.SaveChangesAsync();
        _context.Entry(car).State = EntityState.Detached;
        return car;
    }

    public async Task DeleteCar(int id)
    {
        var car = await _context.Cars.FindAsync(id);
        if (car == null)
        {
            throw new NotFoundException("Car not found");
        }

        _context.Cars.Remove(car);
        await _context.SaveChangesAsync();
    }
}
