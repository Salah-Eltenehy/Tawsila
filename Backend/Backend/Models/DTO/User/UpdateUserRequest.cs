using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record UpdateUserRequest(
    [Required] string Email,
    [Required] string FirstName,
    [Required] string LastName,
    [Required] string PhoneNumber,
    string? Avatar,
    [Required] bool HasWhatsapp
);
