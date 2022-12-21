namespace Backend.Models.API.CarAPI;
using System.ComponentModel.DataAnnotations;

public record UpdateCarRequest(
    [Required] string Brand,
    [Required] string Model,
    [Required] int Year,
    [Required] int Price,
    [Required] int SeatsCount,
    [Required] string Transmission,
    [Required] string FuelType,
    [Required] string BodyType,
    [Required] bool HasAirConditioning,
    [Required] bool HasAbs,
    [Required] bool HasRadio,
    [Required] bool HasSunroof,
    [Required] int Period,
    [Required] string Description,
    [Required] double Longitude,
    [Required] double Latitude
);
