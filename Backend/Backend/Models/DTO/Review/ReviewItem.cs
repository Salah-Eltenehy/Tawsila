using System.ComponentModel.DataAnnotations;

namespace Backend.Models.DTO.Review;
public record ReviewItem(

    [Required] int Id,

    [Required] int Rating ,

    [Required] string Comment,

    [Required] DateTime CreatedAt,

    [Required] DateTime UpdatedAt
    
    );
