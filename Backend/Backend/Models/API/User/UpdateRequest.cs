using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record UpdateRequest
(
    [Required] string Email,
    [Required] string FirstName,
    [Required] string LastName,
    [Required] string PhoneNumber,
    [Required] bool HasWhatsapp
);