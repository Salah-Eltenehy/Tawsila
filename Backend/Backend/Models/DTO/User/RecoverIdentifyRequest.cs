using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record RecoverIdentifyRequest(
    [Required] string Email
);
