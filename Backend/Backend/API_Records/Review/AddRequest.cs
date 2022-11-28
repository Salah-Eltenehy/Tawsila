using System.ComponentModel.DataAnnotations;

public record ReviewRequest
    (
    int rating,
    string comment,
    int reviewee,
    int reviewer
    );
