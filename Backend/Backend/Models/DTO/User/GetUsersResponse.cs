using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record GetUsersResponse([Required] UserItem[] Users);
