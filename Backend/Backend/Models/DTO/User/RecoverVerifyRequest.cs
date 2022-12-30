using System.ComponentModel.DataAnnotations;

namespace Backend.Models.API.User;

public record RecoverVerifyRequest([Required] string VerificationCode);
