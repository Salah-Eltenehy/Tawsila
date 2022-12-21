using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

/// <summary>Result of logging a user in.</summary>
/// <param name = "Token">Issued JWT token.</param>
public record TokenResponse([Required] string Token);
