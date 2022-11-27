using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models;

public class User
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int userId { get; set; }
    
    [Required]
    [Unicode]
    [MaxLength(255)]
    public string email { get; set; }
    
    [Required]
    [Unicode(false)]
    [MaxLength(255)]
    public string password { get; set; }
    
    [Required]
    [Unicode]
    [MaxLength(255)]
    public string firstName { get; set; }
    
    [Required]
    [Unicode]
    [MaxLength(255)]
    public string lastName { get; set; }
    [Required]
    [Unicode(false)]
    [MaxLength(255)]
    public string phoneNumber { get; set; }
    [Required]
    public bool hasPhoto { get; set; } = false;
    [Required]
    public bool hasWhatsapp { get; set; } = false;
    [Required]
    public bool isEmailVerified { get; set; } = false;
    [Required]
    public DateTime createdAt { get; set; }
    [Required]
    public DateTime updatedAt { get; set; }

    public virtual List<Car> cars { get; set; }
    public virtual List<Review> reviews { get; set; }
    public virtual List<Review> reviewsCreated { get; set; }
    
}
