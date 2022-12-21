using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record VerifyUserRequest([Required] string EmailVerificationCode);
