using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API;

public record ErrorResponse([Required] string message);
