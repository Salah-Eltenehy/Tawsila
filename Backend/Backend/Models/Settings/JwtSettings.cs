namespace Backend.Models.Settings;

public class JwtSettings
{
    public string Audience { get; set; } = null!;
    public string Issuer { get; set; } = null!;
    public string Secret { get; set; } = null!;
}