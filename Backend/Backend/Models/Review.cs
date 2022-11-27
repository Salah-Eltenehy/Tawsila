using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models;

public class Review
{
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int id { get; set; }
    [Required]
    public int rating { get; set; }
    public string comment { get; set; }
    [Required]
    public DateTime createdAt { get; set; }
    [Required]
    public DateTime updatedAt { get; set; }

    
    public int reviewerId { get; set; }
    public User reviewer { get; set; }
    


    public int revieweeId { get; set; }
    public User reviewee { get; set; }

}
