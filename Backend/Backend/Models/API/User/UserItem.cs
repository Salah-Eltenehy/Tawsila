using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record UserItem
(
    [Required] int Id,
    [Required] string FirstName,
    [Required] string LastName,
    [Required] string PhoneNumber,
    [Required] bool HasWhatsapp,
    [Required] string CreatedAt
);