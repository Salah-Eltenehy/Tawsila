using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.CarAPI;

public record GetCarsRequest(
    string? Brands,
    string? Models,
    int? MinYear,
    int? MaxYear,
    int? MinPrice,
    int? MaxPrice,
    int? SeatsCount,
    string? Transmission,
    string? FuelTypes,
    string? BodyTypes,
    bool? HasAirConditioning,
    bool? HasAbs,
    bool? HasRadio,
    bool? HasSunroof,
    [Required] double Longitude,
    [Required] double Latitude,
    string? SortBy,
    int? Offset
);
