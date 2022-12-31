using System.ComponentModel.DataAnnotations;

namespace Backend.Models.DTO.Review;
public record UpdateReviewRequest(

    [Required] int Rating,

    [Required] string Comment
 );
