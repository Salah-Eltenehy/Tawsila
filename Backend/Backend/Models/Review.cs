using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models;

public class Review
{
    [Key]
    public int id { get; set; }
    [Required]
    public int rating { get; set; }
    public string comment { get; set; }
    [Required]
    public DateTime createdAt { get; set; }
    [Required]
    public DateTime updatedAt { get; set; }

    [ForeignKey("User")]
    public int revieweeId { get; set; }
    //public virtual User reviewee { get; set; }
    [ForeignKey("User")]
    public int reviewerId { get; set; }
    //public virtual User reviewer { get; set; }
    
}
