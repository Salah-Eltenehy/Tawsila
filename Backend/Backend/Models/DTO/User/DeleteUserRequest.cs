using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record DeleteUserRequest([Required] string Password);
