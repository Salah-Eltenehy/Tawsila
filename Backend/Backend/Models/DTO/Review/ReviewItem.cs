using System.ComponentModel.DataAnnotations;

namespace Backend.Models.DTO.Review;
public record ReviewItem(

    [Required] int Id,

    [Required] int Rating ,

    [Required] string Content,

    [Required] int reviewerId,

    [Required] string reviewerFirstName,

    [Required] string reviewerLastName,

    [Required] string reviewerAvatar,

    [Required] DateTime CreatedAt,

    [Required] DateTime UpdatedAt

    );
