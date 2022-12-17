namespace Backend.Models.API.CarAPI;
using System.ComponentModel.DataAnnotations;

public record CarRequest
(
    [Required] string brand,
    [Required] string model,
    [Required] int year,
    [Required] int price,
    [Required] int seatsCount,
    [Required] string transmission,
    [Required] string fuelType,
    [Required] string bodyType,
    [Required] bool hasAirConditioning,
    [Required] bool hasAbs,
    [Required] bool hasRadio,
    [Required] bool hasSunroof,
    [Required] int period,
    [Required] string description,
    [Required] double longitude,
    [Required] double latitude
);
