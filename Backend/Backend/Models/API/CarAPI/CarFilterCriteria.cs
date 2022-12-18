using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.CarAPI;

public record CarFilterCriteria
(
    string brand,
    string model,
    string year,
    string price,
    string transmission,
    string fuelType,
    string bodyType,
    string options,
    double latitude,
    double longitude
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


