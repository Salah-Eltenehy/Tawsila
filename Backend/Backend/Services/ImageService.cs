using Backend.Models.Exceptions;
/*using ImageMagick;*/
using System.Text.RegularExpressions;

namespace Backend.Services;

public interface IImageService
{
    byte[] DecodeBase64(string base64);
}

public class ImageService : IImageService
{
    public byte[] DecodeBase64(string base64)
    {
        Regex base64Regex = new Regex(@"^([a-zA-Z0-9\+/]+={0,2})$");
        Match match = base64Regex.Match(base64);
        if (!match.Success)
        {
            throw new BadRequestException("Invalid image");
        }
        
        string base64String = match.Groups[1].Value;
        byte[] bytes = Convert.FromBase64String(base64String);
/*        try
        {
            using MagickImage image = new(bytes);
        }
        catch (MagickCorruptImageErrorException)
        {
            throw new BadRequestException("Invalid image");
        }*/
        return bytes;
    }
}
