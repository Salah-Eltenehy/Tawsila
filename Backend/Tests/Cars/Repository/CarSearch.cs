using Microsoft.EntityFrameworkCore;
using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Contexts;
using Backend.Models.Exceptions;
using Backend.Models.API.CarAPI;

namespace Tests.Cars.Repository;
public class CarSearch : IDisposable
{
    private readonly TawsilaContext _context;
    private readonly CarRepo _carRepo;
    private readonly GetCarsRequest _getCarsRequestTemplate;
    private readonly Car _dummyCar1;
    private readonly Car _dummyCar2;
    private readonly Car _dummyCar3;
    private readonly Car _dummyCar4;
    private readonly Car _dummyCar5;
    private readonly Car _dummyCar6;
    private readonly Car _dummyCar7;
    private readonly Car _dummyCar8;
    private readonly Car _dummyCar9;
    private readonly Car _dummyCar10;

    public CarSearch()
    {
        var options = new DbContextOptionsBuilder<TawsilaContext>()
            .UseInMemoryDatabase(databaseName: "TawsilaDB")
            .Options;
        _context = new TawsilaContext(options);
        _carRepo = new CarRepo(_context);
        _getCarsRequestTemplate = new GetCarsRequest
        (
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, 30, 30, null, null
        );
        _dummyCar1 = new Car
        {
            Brand = "toyota",
            Model = "corolla",
            Year = 2010,
            Price = 1000,
            SeatsCount = 5,
            Transmission = "automatic",
            FuelType = "gasoline",
            BodyType = "sedan",
            HasAirConditioning = true,
            HasAbs = true,
            HasRadio = true,
            HasSunroof = true,
            Period = 3,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = -96.84411587,
            Latitude = 37.79239391,
            OwnerId = 1
        };
        _dummyCar2 = new Car
        {
            Brand = "gmc",
            Model = "yukon",
            Year = 2001,
            Price = 6298,
            SeatsCount = 4,
            Transmission = "automatic",
            FuelType = "natural_gas",
            BodyType = "sedan",
            HasAirConditioning = false,
            HasAbs = true,
            HasRadio = false,
            HasSunroof = true,
            Period = 10,
            Description = "A car that is perfect for a family",
            Images = new string[] { "image1", "image2" },
            Longitude = -96.83680478,
            Latitude = 37.78299547,
            OwnerId = 1
        };
        _dummyCar3 = new Car
        {
            Brand = "kia",
            Model = "rio",
            Year = 2015,
            Price = 50,
            SeatsCount = 2,
            Transmission = "manual",
            FuelType = "gasoline",
            BodyType = "sport",
            HasAirConditioning = true,
            HasAbs = true,
            HasRadio = false,
            HasSunroof = false,
            Period = 1,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = -96.86492382,
            Latitude = 37.79834132,
            OwnerId = 1
        };
        _dummyCar4 = new Car
        {
            Brand = "fiat",
            Model = "500",
            Year = 1999,
            Price = 200,
            SeatsCount = 4,
            Transmission = "manual",
            FuelType = "gasoline",
            BodyType = "xuv",
            HasAirConditioning = false,
            HasAbs = false,
            HasRadio = false,
            HasSunroof = false,
            Period = 23,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = -119.20043449,
            Latitude = 47.06181315,
            OwnerId = 1
        };
        _dummyCar5 = new Car
        {
            Brand = "ford",
            Model = "mustang",
            Year = 2010,
            Price = 1500,
            SeatsCount = 2,
            Transmission = "automatic",
            FuelType = "natural_gas",
            BodyType = "sedan",
            HasAirConditioning = false,
            HasAbs = false,
            HasRadio = false,
            HasSunroof = true,
            Period = 3,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = -119.18094227,
            Latitude = 47.06734837,
            OwnerId = 1
        };
        _dummyCar6 = new Car
        {
            Brand = "kia",
            Model = "cerato",
            Year = 2010,
            Price = 1050,
            SeatsCount = 4,
            Transmission = "automatic",
            FuelType = "natural_gas",
            BodyType = "compact",
            HasAirConditioning = true,
            HasAbs = true,
            HasRadio = true,
            HasSunroof = true,
            Period = 39,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = -119.19457829,
            Latitude = 47.06394462,
            OwnerId = 1
        };
        _dummyCar7 = new Car
        {
            Brand = "volkswagen",
            Model = "golf",
            Year = 1974,
            Price = 125,
            SeatsCount = 4,
            Transmission = "automatic",
            FuelType = "gasoline",
            BodyType = "compact",
            HasAirConditioning = false,
            HasAbs = false,
            HasRadio = true,
            HasSunroof = false,
            Period = 3,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = 31.29050679,
            Latitude = 30.27326606,
            OwnerId = 1
        };
        _dummyCar8 = new Car
        {
            Brand = "toyota",
            Model = "camry",
            Year = 1982,
            Price = 1250,
            SeatsCount = 5,
            Transmission = "automatic",
            FuelType = "natural_gas",
            BodyType = "sedan",
            HasAirConditioning = false,
            HasAbs = false,
            HasRadio = false,
            HasSunroof = false,
            Period = 7,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = 31.29229102,
            Latitude = 30.27463454,
            OwnerId = 1
        };
        _dummyCar9 = new Car
        {
            Brand = "fiat",
            Model = "124",
            Year = 1972,
            Price = 99,
            SeatsCount = 2,
            Transmission = "manual",
            FuelType = "gasoline",
            BodyType = "sport",
            HasAirConditioning = false,
            HasAbs = false,
            HasRadio = true,
            HasSunroof = true,
            Period = 1,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = 31.29134210,
            Latitude = 30.27696787,
            OwnerId = 1
        };
        _dummyCar10 = new Car
        {
            Brand = "ford",
            Model = "fiesta",
            Year = 2010,
            Price = 1000,
            SeatsCount = 4,
            Transmission = "automatic",
            FuelType = "natural_gas",
            BodyType = "compact",
            HasAirConditioning = true,
            HasAbs = true,
            HasRadio = true,
            HasSunroof = true,
            Period = 3,
            Description = "Good car",
            Images = new string[] { "image1", "image2" },
            Longitude = 31.28963270,
            Latitude = 30.27603582,
            OwnerId = 1
        };
        _context.Cars.Add((Car)_dummyCar1.Clone());
        _context.Cars.Add((Car)_dummyCar2.Clone());
        _context.Cars.Add((Car)_dummyCar3.Clone());
        _context.Cars.Add((Car)_dummyCar4.Clone());
        _context.Cars.Add((Car)_dummyCar5.Clone());
        _context.Cars.Add((Car)_dummyCar6.Clone());
        _context.Cars.Add((Car)_dummyCar7.Clone());
        _context.Cars.Add((Car)_dummyCar8.Clone());
        _context.Cars.Add((Car)_dummyCar9.Clone());
        _context.Cars.Add((Car)_dummyCar10.Clone());
        _context.SaveChanges();
    }

    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _context.Dispose();
    }

    [Fact]
    public async Task Region1()
    {
        var getCarsRequest = _getCarsRequestTemplate with
        {
            Longitude = -96.84411,
            Latitude = 37.79237
        };
        var result = await _carRepo.GetCars(getCarsRequest);
        Assert.Equal(3, result.TotalCount);
        Assert.Equal(3, result.Items.Length);
        result.Items.Should().ContainEquivalentOf(_dummyCar1, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
        result.Items.Should().ContainEquivalentOf(_dummyCar2, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
        result.Items.Should().ContainEquivalentOf(_dummyCar3, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task Region2()
    {
        var getCarsRequest = _getCarsRequestTemplate with
        {
            Longitude = -119.19457829,
            Latitude = 47.06394462
        };
        var result = await _carRepo.GetCars(getCarsRequest);
        Assert.Equal(3, result.TotalCount);
        Assert.Equal(3, result.Items.Length);
        result.Items.Should().ContainEquivalentOf(_dummyCar4, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
        result.Items.Should().ContainEquivalentOf(_dummyCar5, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
        result.Items.Should().ContainEquivalentOf(_dummyCar6, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task ToyotaBrandRegion1()
    {
        var getCarsRequest = _getCarsRequestTemplate with
        {
            Brands = "toyota",
            Longitude = -96.84411,
            Latitude = 37.79237
        };
        var result = await _carRepo.GetCars(getCarsRequest);
        Assert.Equal(1, result.TotalCount);
        Assert.Single(result.Items);
        result.Items.Should().ContainEquivalentOf(_dummyCar1, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task ToyotaBrandRegion3()
    {
        var getCarsRequest = _getCarsRequestTemplate with
        {
            Brands = "toyota",
            Longitude = 31.24,
            Latitude = 30.3
        };
        var result = await _carRepo.GetCars(getCarsRequest);
        Assert.Equal(1, result.TotalCount);
        Assert.Single(result.Items);
        result.Items.Should().ContainEquivalentOf(_dummyCar8, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task FiatKiaBrandRegion2()
    {
        var getCarsRequest = _getCarsRequestTemplate with
        {
            Brands = "fiat,kia",
            Longitude = -119.19457829,
            Latitude = 47.06394462
        };
        var result = await _carRepo.GetCars(getCarsRequest);
        Assert.Equal(2, result.TotalCount);
        Assert.Equal(2, result.Items.Length);
        result.Items.Should().ContainEquivalentOf(_dummyCar4, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
        result.Items.Should().ContainEquivalentOf(_dummyCar6, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task CompactBodyTypeRegion3()
    {
        var getCarsRequest = _getCarsRequestTemplate with
        {
            BodyTypes = "compact",
            Longitude = 31.24,
            Latitude = 30.3
        };
        var result = await _carRepo.GetCars(getCarsRequest);
        Assert.Equal(2, result.TotalCount);
        Assert.Equal(2, result.Items.Length);
        result.Items.Should().ContainEquivalentOf(_dummyCar7, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
        result.Items.Should().ContainEquivalentOf(_dummyCar10, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task CompactBodyTypeHasAirConditioningRegion3()
    {
        var getCarsRequest = _getCarsRequestTemplate with
        {
            BodyTypes = "compact",
            HasAirConditioning = true,
            Longitude = 31.24,
            Latitude = 30.3
        };
        var result = await _carRepo.GetCars(getCarsRequest);
        Assert.Equal(1, result.TotalCount);
        Assert.Single(result.Items);
        result.Items.Should().ContainEquivalentOf(_dummyCar10, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task GasolineFuelTypeRegion1()
    {
        var getCarsRequest = _getCarsRequestTemplate with
        {
            FuelTypes = "gasoline",
            Longitude = -96.84411,
            Latitude = 37.79237
        };
        var result = await _carRepo.GetCars(getCarsRequest);
        Assert.Equal(2, result.TotalCount);
        Assert.Equal(2, result.Items.Length);
        result.Items.Should().ContainEquivalentOf(_dummyCar1, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
        result.Items.Should().ContainEquivalentOf(_dummyCar3, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task AutomaticTransmissionGasolineFuelTypeRegion1()
    {
        var getCarsRequest = _getCarsRequestTemplate with
        {
            Transmission = "automatic",
            FuelTypes = "gasoline",
            Longitude = -96.84411,
            Latitude = 37.79237
        };
        var result = await _carRepo.GetCars(getCarsRequest);
        Assert.Equal(1, result.TotalCount);
        Assert.Single(result.Items);
        result.Items.Should().ContainEquivalentOf(_dummyCar1, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task InvalidMinPrice()
    {
        var invalidGetCarRequest = _getCarsRequestTemplate with { MinPrice = 49 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.GetCars(invalidGetCarRequest));
        Assert.Equal("Minimum price cannot be less than 50", ex.Message);
    }

    [Fact]
    public async Task InvalidMaxPrice()
    {
        var invalidGetCarRequest = _getCarsRequestTemplate with { MaxPrice = 49 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.GetCars(invalidGetCarRequest));
        Assert.Equal("Maximum price cannot be less than 50", ex.Message);
    }

    [Fact]
    public async Task InvalidMinYear()
    {
        var invalidGetCarRequest = _getCarsRequestTemplate with { MinYear = 1900 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.GetCars(invalidGetCarRequest));
        Assert.Equal("Minimum year cannot be less than 1901", ex.Message);
    }

    [Fact]
    public async Task InvalidMaxYear()
    {
        var invalidGetCarRequest = _getCarsRequestTemplate with { MaxYear = 1900 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.GetCars(invalidGetCarRequest));
        Assert.Equal("Maximum year cannot be less than 1901", ex.Message);
    }

    [Fact]
    public async Task InvalidSeatsCount()
    {
        var invalidGetCarRequest = _getCarsRequestTemplate with { SeatsCount = 0 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.GetCars(invalidGetCarRequest));
        Assert.Equal("Seats count cannot be less than 1", ex.Message);
    }

    [Fact]
    public async Task InvalidLongitude()
    {
        var invalidGetCarRequest = _getCarsRequestTemplate with { Longitude = -180.21 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.GetCars(invalidGetCarRequest));
        Assert.Equal("Longitude must be between -180 and 180", ex.Message);
    }

    [Fact]
    public async Task InvalidLatitude()
    {
        var invalidGetCarRequest = _getCarsRequestTemplate with { Latitude = 90.01 };
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(() => _carRepo.GetCars(invalidGetCarRequest));
        Assert.Equal("Latitude must be between -90 and 90", ex.Message);
    }

}