using System.ComponentModel.DataAnnotations;

namespace Backend.Models.DTO.Review;
public record CreateReviewRequest(

    [Required] int Rating,

    [Required] string Comment,

    [Required] int Reviewee
 );
