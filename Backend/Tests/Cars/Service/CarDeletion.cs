using Microsoft.EntityFrameworkCore;
using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Contexts;
using Backend.Services;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Mvc;

namespace Tests.Cars.Service;
public class CarCreation
{
    private readonly Mock<ICarRepo> _carRepo;
    private readonly Mock<IImageService> _imageService;
    private readonly Mock<IStorageService> _storageSercie;
    private readonly ICarService _carService;
    private readonly Car _dummyCar;
    public CarCreation()
    {
        _carRepo = new Mock<ICarRepo>();
        _imageService = new Mock<IImageService>();
        _storageSercie = new Mock<IStorageService>();
        _carService = new CarService(_carRepo.Object, _imageService.Object, _storageSercie.Object);
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
    public async Task ExistentCarAuthorized()
    {
        _carRepo.Setup(x => x.GetCar(1)).ReturnsAsync(_dummyCar);
        var exception = await Record.ExceptionAsync(async () => await _carService.DeleteCar(1, 1));
        Assert.Null(exception);
    }

    [Fact]
    public async Task ExistentCarUnauthorized()
    {
        _carRepo.Setup(x => x.GetCar(1)).ReturnsAsync(_dummyCar);
        UnauthorizedException ex = await Assert.ThrowsAsync<UnauthorizedException>(async () => await _carService.DeleteCar(2, 1));
        Assert.Equal("You can only Delete your cars", ex.Message);
    }

    [Fact]
    public async Task NonExistentCar()
    {
        _carRepo.Setup(x => x.GetCar(1)).ReturnsAsync(_dummyCar);
        NotFoundException ex = await Assert.ThrowsAsync<NotFoundException>(async () => await _carService.DeleteCar(1, 2));
        Assert.Equal("Car not found", ex.Message);
    }

}