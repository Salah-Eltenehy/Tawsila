using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Backend.Models.Entities;

public class Review
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int Id { get; set; }

    [Required]
    public int Rating { get; set; }

    [Required]
    [Unicode]
    public string Comment { get; set; } = null!;

    [Required]
    public DateTime CreatedAt { get; set; }

    [Required]
    public DateTime UpdatedAt { get; set; }

    [ForeignKey("Reviewer")]
    public int ReviewerId { get; set; }
    public User Reviewer { get; set; } = null!;

    [ForeignKey("Reviewee")]
    public int RevieweeId { get; set; }
    public User Reviewee { get; set; } = null!;
}
