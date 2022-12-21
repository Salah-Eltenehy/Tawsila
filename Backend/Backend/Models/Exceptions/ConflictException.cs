namespace Backend.Models.Exceptions;

public class ConflictException : Exception
{
    public ConflictException(string message) : base(message) { }
}
