using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models;

public class Car
{
    [Key]
    public int id { get; set; }
    [Required]
    public string Brand { get; set; }
    [Required]
    public string Model { get; set; }
    public int Year { get; set; }
    [Required]
    public int Price { get; set; }
    [Required]
    public int SeatsCount { get; set; }
    [Required]
    public string Transmision { get; set; }
    [Required]
    public string FeulType { get; set; }
    public string BodyType { get; set; }
    [Required]
    public bool HasAirConditioning { get; set; }
    public bool HasAbs { get; set; }
    [Required]
    public bool HasRadio { get; set; }
    public bool HasSunRoof { get; set; }
    [Required]
    public int period { get; set; }
    public string description { get; set; }
    //[Required]
    //public string[] images { get; set; }
    [Required]
    public double longitude { get; set; }
    [Required]
    public double latidude { get; set; }
    [Required]
    public bool isListed { get; set; }
    [Required]
    public DateTime createdAt { get; set; }
    [Required]
    public DateTime updatedAt { get; set; }

    [ForeignKey("User")]
    public int ownerId { get; set; }
    
    //public virtual User owner { get; set; }

}
