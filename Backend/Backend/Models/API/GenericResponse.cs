using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API;

public record GenericResponse(
    [Required] string message
);