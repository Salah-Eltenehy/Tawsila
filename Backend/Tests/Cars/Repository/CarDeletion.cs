using Microsoft.EntityFrameworkCore;
using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Contexts;
using Backend.Services;
using Backend.Models.Exceptions;

namespace Tests.Cars.Repository;
public class CarDeletion : IDisposable
{
    private readonly TawsilaContext _context;
    private readonly CarRepo _carRepo;
    private readonly Car _dummyCar;
    public CarDeletion()
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
    public async Task ExistentCar()
    {
        _context.Cars.Add(_dummyCar);
        await _context.SaveChangesAsync();
        await _carRepo.DeleteCar(1);
        var car = await _context.Cars.FindAsync(1);
        Assert.Null(car);
    }

    [Fact]
    public async Task NonExistentCar()
    {
        NotFoundException ex = await Assert.ThrowsAsync<NotFoundException>(() => _carRepo.DeleteCar(1));
        Assert.Equal("Car not found", ex.Message);
    }

}