using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.CarAPI;

public record CarFilterCriteria
(
    [Required] string brand,
    [Required] string model,
    [Required] string year,
    [Required] string price,
    [Required] string transmission,
    [Required] string fuelType,
    [Required] string bodyType,
    [Required] string options,
    [Required] double latitude,
    [Required] double longitude
);
/*
 *     [Required] bool hasAirConditioning,
    [Required] bool hasAbs,
    [Required] bool hasRadio,
    [Required] bool hasSunroof*/
//[Required] int seatsCount,
//[Required] int period,
//[Required] string description
//[Required] double longitude,
//[Required] double latitude


