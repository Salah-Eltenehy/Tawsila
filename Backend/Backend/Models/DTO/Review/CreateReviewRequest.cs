using System.ComponentModel.DataAnnotations;

namespace Backend.Models.DTO.Review;
public record CreateReviewRequest(

    [Required] int Rating,

    [Required] string Comment,

    [Required] DateTime CreatedAt,

    [Required] DateTime UpdatedAt,

    int RevieweeId
 );
