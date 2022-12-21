using Microsoft.EntityFrameworkCore;
using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Contexts;
using Backend.Services;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Mvc;
using Backend.Models.API.CarAPI;
using Backend.Models;

namespace Tests.Cars.Service;
public class CarSearch
{
    private readonly Mock<ICarRepo> _carRepo;
    private readonly Mock<IImageService> _imageService;
    private readonly Mock<IStorageService> _storageSercie;
    private readonly ICarService _carService;
    private readonly GetCarsRequest _getCarsRequestTemplate;
    private readonly Car _dummyCar;
    public CarSearch()
    {
        _carRepo = new Mock<ICarRepo>();
        _imageService = new Mock<IImageService>();
        _storageSercie = new Mock<IStorageService>();
        _carService = new CarService(_carRepo.Object, _imageService.Object, _storageSercie.Object);
        _getCarsRequestTemplate = new GetCarsRequest
        (
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, 30, 30, null, null
        );
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

    [Fact]
    public async Task ValidCarSearch()
    {
        _carRepo.Setup(x => x.GetCars(_getCarsRequestTemplate)).ReturnsAsync(new PaginatedList<Car>(new Car[] { _dummyCar }, 1, 0));
        var result = await _carService.GetCars(_getCarsRequestTemplate);
        Assert.Equal(1, result.TotalCount);
        Assert.Single(result.Items);
        result.Items.Should().ContainEquivalentOf(_dummyCar, options => options
            .Excluding(s => s.Id)
            .Excluding(s => s.CreatedAt)
            .Excluding(s => s.UpdatedAt));
    }

    [Fact]
    public async Task InvalidCarSearch()
    {
        var invalidGetCarRequest = _getCarsRequestTemplate with { MaxPrice = 49 };
        _carRepo.Setup(x => x.GetCars(invalidGetCarRequest)).ThrowsAsync(new BadRequestException("Maximum price cannot be less than 50"));
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(async () => await _carService.GetCars(invalidGetCarRequest));
        Assert.Equal("Maximum price cannot be less than 50", ex.Message);
    }

}