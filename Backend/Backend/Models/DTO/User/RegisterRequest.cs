using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record RegisterRequest(
    [Required] string Email,
    [Required] string Password,
    [Required] string FirstName,
    [Required] string LastName,
    [Required] string PhoneNumber,
    [Required] bool HasWhatsapp
);
