using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
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
    [JsonIgnore]
    public User reviewee { get; set; }

}
