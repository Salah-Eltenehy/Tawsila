using Microsoft.EntityFrameworkCore;
using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Contexts;
using Backend.Models.Exceptions;
using Backend.Models.API.CarAPI;

namespace Tests.Cars.Repository;
public class CarUpdate : IDisposable
{
    private readonly TawsilaContext _context;
    private readonly CarRepo _carRepo;
    private readonly Car _dummyCar;
    private readonly Car _dummyUpdatedCar;
    private readonly UpdateCarRequest _dummyCarUpdate;
    public CarUpdate()
    {
        var options = new DbContextOptionsBuilder<TawsilaContext>()
            .UseInMemoryDatabase(databaseName: "TawsilaDB")
            .Options;
        _context = new TawsilaContext(options);
        _carRepo = new CarRepo(_context);
        _dummyCar = new Car
        {
            Brand = "Toyota",
            Model = "Corolla",
            Year = 2010,
            Price = 1000,
            SeatsCount = 5,
            Transmission = "Automatic",
            FuelType = "Gasoline",
            BodyType = "Sedan",
            HasAirConditioning = true,
            HasAbs = true,
            HasRadio = true,
            HasSunroof = true,
            Period = 3,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = 30.123,
            Latitude = 30.123,
            OwnerId = 1
        };
        _dummyCarUpdate = new UpdateCarRequest
        (
            "Kia", "Rio", 2015, 2000, 4, "Manual", "Diesel", "Hatchback",
            false, false, false, false, 2, "Bad car", 54.125, 54.125
        );
        _dummyUpdatedCar = new Car
        {
            Id = 1,
            Brand = "Kia",
            Model = "Rio",
            Year = 2015,
            Price = 2000,
            SeatsCount = 4,
            Transmission = "Manual",
            FuelType = "Diesel",
            BodyType = "Hatchback",
            HasAirConditioning = false,
            HasAbs = false,
            HasRadio = false,
            HasSunroof = false,
            Period = 2,
            Description = "Bad car",
            Images = new string[] { "image1", "image2" },
            Longitude = 54.125,
            Latitude = 54.125,
            OwnerId = 1
        };
        _context.Cars.Add(_dummyCar);
        _context.SaveChangesAsync();
    }

    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _context.Dispose();
    }

    [Fact]
    public async Task ValidUpdate()
    {
        await _carRepo.UpdateCar(1, _dummyCarUpdate);
        var car = await _context.Cars.FindAsync(1);
        car.WithDeepEqual(_dummyUpdatedCar)
            .IgnoreSourceProperty(x => x!.Id)
            .IgnoreSourceProperty(x => x!.CreatedAt)
            .IgnoreSourceProperty(x => x!.UpdatedAt)
            .Assert();
    }

    [Fact]
    public async Task InvalidPrice()
    {
        var invalidCarUpdate = _dummyCarUpdate with { Price = 49 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.UpdateCar(1, invalidCarUpdate));
        Assert.Equal("Price cannot be less than 50", ex.Message);
    }

    [Fact]
    public async Task InvalidYear()
    {
        var invalidCarUpdate = _dummyCarUpdate with { Year = 1900 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.UpdateCar(1, invalidCarUpdate));
        Assert.Equal("Year cannot be less than 1901", ex.Message);
    }

    [Fact]
    public async Task InvalidSeatsCount()
    {
        var invalidCarUpdate = _dummyCarUpdate with { SeatsCount = 0 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.UpdateCar(1, invalidCarUpdate));
        Assert.Equal("Seats count cannot be less than 1", ex.Message);
    }

    [Fact]
    public async Task InvalidPeriod()
    {
        var invalidCarUpdate = _dummyCarUpdate with { Period = 0 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.UpdateCar(1, invalidCarUpdate));
        Assert.Equal("Period cannot be less than 1", ex.Message);
    }

    [Fact]
    public async Task InvalidLongitude()
    {
        var invalidCarUpdate = _dummyCarUpdate with { Longitude = -180.21 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.UpdateCar(1, invalidCarUpdate));
        Assert.Equal("Longitude must be between -180 and 180", ex.Message);
    }

    [Fact]
    public async Task InvalidLatitude()
    {
        var invalidCarUpdate = _dummyCarUpdate with { Latitude = 90.01 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.UpdateCar(1, invalidCarUpdate));
        Assert.Equal("Latitude must be between -90 and 90", ex.Message);
    }

}