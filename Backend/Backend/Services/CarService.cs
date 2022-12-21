using Backend.Models;
using Backend.Models.API.CarAPI;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Backend.Repositories;

namespace Backend.Services;

public interface ICarService
{
    public Task<Car> GetCar(int carId);
    public Task<PaginatedList<Car>> GetCars(GetCarsRequest req);
    public Task CreateCar(int UserId, CreateCarRequest car);
    public Task UpdateCar(int UserId, int carId, UpdateCarRequest car);
    public Task DeleteCar(int UserId, int CarId);
}

public class CarService : ICarService
{
    private readonly ICarRepo _carRepo;
    private readonly IImageService _imageService;
    private readonly IStorageService _storageService;

    public CarService(ICarRepo carRepo, IImageService imageService, IStorageService storageService)
    {
        _carRepo = carRepo;
        _imageService = imageService;
        _storageService = storageService;
    }

    public async Task<Car> GetCar(int carId)
    {
        Car car = await _carRepo.GetCar(carId);
        car.Images = _storageService.GetBlobsUrls("car-images", car.Images);
        return car;
    }

    public async Task<PaginatedList<Car>> GetCars(GetCarsRequest req)
    {
        PaginatedList<Car> cars = await _carRepo.GetCars(req);
        for (int i = 0; i < cars.Items.Length; i++)
        {
            cars.Items[i].Images = _storageService.GetBlobsUrls("car-images", cars.Items[i].Images);
        }

        return cars;
    }

    public async Task CreateCar(int UserId, CreateCarRequest req)
    {
        string[] images = req.Images;
        Stream[] imagesStreams = new Stream[images.Length];

        for (int i = 0; i < images.Length; i++)
        {
            Stream ms = new MemoryStream(_imageService.DecodeBase64(images[i]));
            imagesStreams[i] = ms;
        }

        string[] imageFileNames = await _storageService.UploadStreams("car-images", imagesStreams, ".jpg");

        Car car = new()
        {
            Brand = req.Brand,
            Model = req.Model,
            Year = req.Year,
            Price = req.Price,
            SeatsCount = req.SeatsCount,
            Transmission = req.Transmission,
            FuelType = req.FuelType,
            BodyType = req.BodyType,
            HasAirConditioning = req.HasAirConditioning,
            HasAbs = req.HasAbs,
            HasRadio = req.HasRadio,
            HasSunroof = req.HasSunroof,
            Period = req.Period,
            Description = req.Description,
            Images = imageFileNames,
            Longitude = req.Longitude,
            Latitude = req.Latitude,
            OwnerId = UserId
        };
        await _carRepo.CreateCar(car);
    }

    public async Task UpdateCar(int UserId, int carId, UpdateCarRequest req)
    {
        Car car = await _carRepo.GetCar(carId);
        if (car == null)
        {
            throw new NotFoundException("Car not found");
        }

        if (car.OwnerId != UserId)
        {
            throw new UnauthorizedAccessException("You can only update your cars");
        }

        await _carRepo.UpdateCar(carId, req);
    }

    public async Task DeleteCar(int UserId, int CarId)
    {
        Car car = await _carRepo.GetCar(CarId);
        if (car == null)
        {
            throw new NotFoundException("Car not found");
        }

        if (car.OwnerId != UserId)
        {
            throw new UnauthorizedException("You can only Delete your cars");
        }

        await _carRepo.DeleteCar(CarId);
    }
}
