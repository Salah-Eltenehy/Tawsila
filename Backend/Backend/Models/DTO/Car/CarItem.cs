using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.CarAPI;

public record CarItem(
    [Required] int Id,
    [Required] string Brand,
    [Required] string Model,
    [Required] int Year,
    [Required] int SeatsCount,
    [Required] bool HasAirConditioning,
    [Required] int Price,
    [Required] string Thumbnail,
    [Required] DateTime UpdatedAt
);
