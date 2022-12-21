namespace Backend.Models.API.Review;

public record ReviewRequest(int rating, string comment, int reviewee, int reviewer);
