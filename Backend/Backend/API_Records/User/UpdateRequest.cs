using System.ComponentModel.DataAnnotations;

public record UpdateRequest
    (
    [Required] string email,
    [Required] string FirstName,
    [Required] string LastName,
    [Required] string Phone,
    [Required] bool HasWhatsapp
    );
