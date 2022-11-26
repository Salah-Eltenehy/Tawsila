using System.ComponentModel.DataAnnotations;

namespace Backend.AuthModels.Users;

/// <summary>Data required to log a user in.</summary>
/// <param name = "Email">Email of the user to be logged in.</param>
/// <param name="Password">Password of the user to be logged in.</param>
public record LoginRequest(
    [Required] string Email,
    [Required] string Password
);