using System.ComponentModel.DataAnnotations;

namespace Backend.AuthModels.Users;

public record RegisterRequest(
    [Required] string Email,
    [Required] string Password,
    [Required] string FirstName,
    [Required] string LastName,
    [Required] string Phone,
    [Required] bool HasWhatsapp,
    [Required] string Governorate
);