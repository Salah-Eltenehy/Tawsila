using System.ComponentModel.DataAnnotations;

namespace Backend.AuthModels.Users;

public record RegisterRequest
    (
    [Required] string email,
    [Required] string FirstName,
    [Required] string LastName, 
    [Required] string password,
    [Required] string phone,
    [Required] bool hasWhatsapp
    );
