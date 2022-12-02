﻿using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Backend.Models.Entities;
using Backend.Models.Settings;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace Backend.Services;

public interface IJwtService
{
    public string IssueToken(User user, DateTime notBefore, string? verificationCode = null);
    public string GetVerificationCode(string email, DateTime time);
    public Task<string> SendVerificationCode(User user);
}

public class JwtService : IJwtService
{
    private readonly JwtSettings _jwtSettings;
    private readonly IMailService _mailService;
    private readonly SigningCredentials _signingCredentials;
    private readonly HMACSHA256 _verificationCodeHasher;

    public JwtService(IOptions<JwtSettings> jwtSettings, IMailService mailService)
    {
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.Value.Secret));
        _signingCredentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        _verificationCodeHasher = new HMACSHA256(Encoding.UTF8.GetBytes(jwtSettings.Value.Secret));
        _jwtSettings = jwtSettings.Value;
        _mailService = mailService;
    }
    
    public string IssueToken(User user, DateTime notBefore, string? verificationCode = null)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.Name, user.Id.ToString()),
            new(ClaimTypes.GivenName, user.FirstName),
            new(ClaimTypes.Surname, user.LastName),
            new(ClaimTypes.Email, user.Email),
            new(ClaimTypes.MobilePhone, user.PhoneNumber),
            new(ClaimTypes.Role, user.IsEmailVerified ? "VerifiedUser" : "UnverifiedUser"),
        };
        var token = new JwtSecurityToken(
            issuer: _jwtSettings.Issuer,
            audience: _jwtSettings.Audience,
            claims: claims,
            notBefore: notBefore,
            expires: notBefore.AddMinutes(60),
            signingCredentials: _signingCredentials
        );
        return new JwtSecurityTokenHandler().WriteToken(token);
    }
    
    public string GetVerificationCode(string email, DateTime time)
    {
        var origin = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
        var diff = time.ToUniversalTime() - origin;
        var str = email + Math.Floor(diff.TotalSeconds);
        var hash = _verificationCodeHasher.ComputeHash(Encoding.UTF8.GetBytes(str));
        var code = BitConverter.ToUInt32(hash, 0) % 1000000;
        return code.ToString("D6");
    }

    public async Task<string> SendVerificationCode(User user)
    {
        var timeNow = DateTime.UtcNow;
        var code = GetVerificationCode(user.Email, timeNow);
        await _mailService.SendEmailAsync(user.Email, "Verification Code",
            $"Your verification code is {code}");
        return IssueToken(user, timeNow, code);
    }
}