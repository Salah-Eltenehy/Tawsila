using Backend.Models.DTO.User;
using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record GetUserCarsResponse(
    [Required] UserCarItem[] Cars
);
