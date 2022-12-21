using Microsoft.EntityFrameworkCore;
using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Contexts;
using Backend.Services;
using Backend.Models.Exceptions;

namespace Tests.Cars.Repository;
public class CarCreation : IDisposable
{
    private readonly TawsilaContext _context;
    private readonly CarRepo _carRepo;
    private readonly Car _dummyCar;
    public CarCreation()
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
    }

    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _context.Dispose();
    }

    [Fact]
    public async Task ValidCar()
    {
        await _carRepo.CreateCar(_dummyCar);
        var car = await _context.Cars.FindAsync(1);
        car.WithDeepEqual(_dummyCar)
            .IgnoreSourceProperty(x => x!.Id)
            .IgnoreSourceProperty(x => x!.CreatedAt)
            .IgnoreSourceProperty(x => x!.UpdatedAt)
            .Assert();
    }

    [Fact]
    public async Task InvalidPrice()
    {
        _dummyCar.Price = 49;
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.CreateCar(_dummyCar));
        Assert.Equal("Price cannot be less than 50", ex.Message);
    }

    [Fact]
    public async Task InvalidYear()
    {
        _dummyCar.Year = 1900;
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.CreateCar(_dummyCar));
        Assert.Equal("Year cannot be less than 1901", ex.Message);
    }

    [Fact]
    public async Task InvalidSeatsCount()
    {
        _dummyCar.SeatsCount = 0;
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.CreateCar(_dummyCar));
        Assert.Equal("Seats count cannot be less than 1", ex.Message);
    }

    [Fact]
    public async Task InvalidPeriod()
    {
        _dummyCar.Period = 0;
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.CreateCar(_dummyCar));
        Assert.Equal("Period cannot be less than 1", ex.Message);
    }

    [Fact]
    public async Task InvalidLongitude()
    {
        _dummyCar.Longitude = -180.21;
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.CreateCar(_dummyCar));
        Assert.Equal("Longitude must be between -180 and 180", ex.Message);
    }

    [Fact]
    public async Task InvalidLatitude()
    {
        _dummyCar.Latitude = 90.01;
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.CreateCar(_dummyCar));
        Assert.Equal("Latitude must be between -90 and 90", ex.Message);
    }

}