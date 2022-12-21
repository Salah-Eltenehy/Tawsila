using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.CarAPI;

public record GetCarsResponse(
    [Required] CarItem[] Cars,
    [Required] int TotalCount,
    [Required] int Offset
);
