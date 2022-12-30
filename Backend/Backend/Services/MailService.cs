using Backend.Models.Settings;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Options;
using MimeKit;

namespace Backend.Services;

public interface IMailService
{
    Task SendEmailAsync(string toEmail, string subject, string body);
}

public class MailService : IMailService
{
    private readonly MailSettings _mailSettings;

    public MailService(IOptions<MailSettings> mailSettings)
    {
        _mailSettings = mailSettings.Value;
    }

    public async Task SendEmailAsync(string toEmail, string subject, string body)
    {
        var email = new MimeMessage
        {
            Sender = MailboxAddress.Parse(_mailSettings.Mail)
        };
        email.To.Add(MailboxAddress.Parse(toEmail));
        email.Subject = subject;
        var builder = new BodyBuilder { HtmlBody = body };
        email.Body = builder.ToMessageBody();
        using var smtp = new SmtpClient();
        #if DEBUG
                await smtp.ConnectAsync(_mailSettings.Host, _mailSettings.Port);
        #else
        await smtp.ConnectAsync(
            _mailSettings.Host,
            _mailSettings.Port,
            SecureSocketOptions.StartTls
        );
        #endif
        await smtp.AuthenticateAsync(_mailSettings.Username, _mailSettings.Password);
        await smtp.SendAsync(email);
        await smtp.DisconnectAsync(true);
    }
}
