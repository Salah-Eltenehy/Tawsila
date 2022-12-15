using Backend.Models.API.CarAPI;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Backend.Repositories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualBasic.FileIO;
using Org.BouncyCastle.Ocsp;

public interface ICarService
{

    public Task<ActionResult<IEnumerable<Car>>> GetCars();
    public Task<ActionResult<Car>> GetCar(int id);
    public Task CreateCar(int UserId, CarRequest car);
    public Task<ActionResult<Car>> UpdateCar(int UserId, int carId, CarRequest car);
    public Task DeleteCar(int UserId, int CarId);

}

namespace Backend.Services
{
    public class CarService : ICarService
    {
        public readonly CarRepo _carRepo;

        public CarService(CarRepo carRepo)
        {
            _carRepo = carRepo;
        }

        public async Task<ActionResult<IEnumerable<Car>>> GetCars()
        {
            return await _carRepo.GetCars();  
        }


        public async Task CreateCar(int UserId, CarRequest carReq)
        {
            var car = new Car
            {
                Brand = carReq.brand,
                Model = carReq.model,
                Year  =carReq.year,
                Price = carReq.price,
                SeatsCount = carReq.seatsCount,
                Transmission  = carReq.transmission,
                FuelType = carReq.fuelType,
                BodyType = carReq.bodyType,
                HasAirConditioning = carReq. hasAirConditioning,
                HasAbs = carReq.hasAbs,
                HasRadio = carReq.hasRadio,
                HasSunroof = carReq.hasSunroof,
                Period = carReq.period, 
                Description = carReq.description,   
                Longitude = carReq.longitude,   
                Latitude = carReq.latitude, 
            };
            car.CreatedAt = DateTime.UtcNow;
            car.UpdatedAt = DateTime.UtcNow;
            car.OwnerId = UserId;
            await _carRepo.PostCar(car);
        }

        public async Task<ActionResult<Car>> GetCar(int id)
        {
            return await _carRepo.GetCar(id);
        }

        public async Task<ActionResult<Car>> UpdateCar(int UserId, int carId, CarRequest carReq)
        {
            var car = await _carRepo.GetCar(carId);
            if(car == null)
            {
                throw new NotFoundException("Car not found");
            }
            if(car.OwnerId != UserId)
            {
                throw new UnauthorizedAccessException("You can only update your cars");
            }

            car.Brand = carReq.brand;
            car.Model = carReq.model;
            car.Year = carReq.year;
            car.Price = carReq.price;
            car.SeatsCount = carReq.seatsCount;
            car.Transmission = carReq.transmission;
            car.FuelType = carReq.fuelType;
            car.BodyType = carReq.bodyType;
            car.HasAirConditioning = carReq.hasAirConditioning;
            car.HasAbs = carReq.hasAbs;
            car.HasRadio = carReq.hasRadio;
            car.HasSunroof = carReq.hasSunroof;
            car.Period = carReq.period;
            car.Description = carReq.description;
            car.Longitude = carReq.longitude;
            car.Latitude = carReq.latitude;
            //////////////////////////////
            car.UpdatedAt = DateTime.UtcNow;

            return await _carRepo.PutCar(carId, car);
        }

        public async Task DeleteCar(int UserId, int CarId)
        {
            var car = await _carRepo.GetCar(CarId);
            if (car == null)
            {
                throw new NotFoundException("Car not found");
            }
            if (car.OwnerId != UserId)
            {
                throw new UnauthorizedAccessException("You can only Delete your cars");
            }
             await _carRepo.DeleteCar(car);
        }
    }
}
