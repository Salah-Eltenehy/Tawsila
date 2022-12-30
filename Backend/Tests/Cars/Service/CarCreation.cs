using Microsoft.EntityFrameworkCore;
using Backend.Models.Entities;
using Backend.Repositories;
using Backend.Contexts;
using Backend.Services;
using Backend.Models.Exceptions;
using Microsoft.AspNetCore.Mvc;
using Backend.Models.API.CarAPI;

namespace Tests.Cars.Service;
public class CarCreation
{
    private readonly Mock<ICarRepo> _carRepo;
    private readonly Mock<IImageService> _imageService;
    private readonly Mock<IStorageService> _storageService;
    private readonly ICarService _carService;
    private readonly CreateCarRequest _dummyCarCreateRequest;
    private readonly Car _dummyCar;
    public CarCreation()
    {
        _carRepo = new Mock<ICarRepo>();
        _imageService = new Mock<IImageService>();
        _storageService = new Mock<IStorageService>();
        _carService = new CarService(_carRepo.Object, _imageService.Object, _storageService.Object);
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
        _dummyCarCreateRequest = new CreateCarRequest
        (
            "Kia", "Rio", 2015, 2000, 4, "Manual", "Diesel", "Hatchback",
            false, false, false, false, 2, "Bad car", 54.125, 54.125, new string[1] { "image1" }
        );
    }

    [Fact]
    public async Task SuccessCarCreation()
    {
        _carRepo.Setup(x => x.CreateCar(_dummyCar)).ReturnsAsync(_dummyCar);
        _storageService.Setup(x => x.UploadStreams(It.IsAny<string>(), It.IsAny<Stream[]>(), It.IsAny<string>())).ReturnsAsync(new string[1] { "image1.jpg" });
        _imageService.Setup(x => x.DecodeBase64(It.IsAny<string>())).Returns(new byte[25]);
        var exception = await Record.ExceptionAsync(async () => await _carService.CreateCar(1, _dummyCarCreateRequest));
        Assert.Null(exception);
    }

    [Fact]
    public async Task FailedCarCreationDueToInvalidImage()
    {
        _carRepo.Setup(x => x.CreateCar(_dummyCar)).ReturnsAsync(_dummyCar);
        _storageService.Setup(x => x.UploadStreams(It.IsAny<string>(), It.IsAny<Stream[]>(), It.IsAny<string>())).ReturnsAsync(new string[1] { "image1.jpg" });
        _imageService.Setup(x => x.DecodeBase64(It.IsAny<string>())).Throws(new BadRequestException("Invalid Image"));
        BadRequestException ex = await Assert.ThrowsAsync<BadRequestException>(async () => await _carService.CreateCar(1, _dummyCarCreateRequest));
        Assert.Equal("Invalid Image", ex.Message);
    }

}