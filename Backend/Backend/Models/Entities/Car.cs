using System.ComponentModel.DataAnnotations;

namespace Backend.Models.Entities;

public class Car : ICloneable
{
    [Key]
    public int Id { get; set; }

    [Required]
    public string Brand { get; set; } = null!;

    [Required]
    public string Model { get; set; } = null!;

    [Required]
    public int Year { get; set; }

    [Required]
    public int Price { get; set; }

    [Required]
    public int SeatsCount { get; set; }

    [Required]
    public string Transmission { get; set; } = null!;

    [Required]
    public string FuelType { get; set; } = null!;

    [Required]
    public string BodyType { get; set; } = null!;

    [Required]
    public bool HasAirConditioning { get; set; }

    [Required]
    public bool HasAbs { get; set; }

    [Required]
    public bool HasRadio { get; set; }

    [Required]
    public bool HasSunroof { get; set; }

    [Required]
    public int Period { get; set; }

    [Required]
    public string Description { get; set; } = null!;

    [Required]
    public string[] Images { get; set; } = null!;

    [Required]
    public double Longitude { get; set; }

    [Required]
    public double Latitude { get; set; }

    [Required]
    public bool IsListed { get; set; } = true;

    [Required]
    public DateTime CreatedAt { get; set; }

    [Required]
    public DateTime UpdatedAt { get; set; }

    [Required]
    public int OwnerId { get; set; }
    
    public virtual User Owner { get; set; } = null!;

    public object Clone()
    {
        return new Car
        {
            Id = Id,
            Brand = Brand,
            Model = Model,
            Year = Year,
            Price = Price,
            SeatsCount = SeatsCount,
            Transmission = Transmission,
            FuelType = FuelType,
            BodyType = BodyType,
            HasAirConditioning = HasAirConditioning,
            HasAbs = HasAbs,
            HasRadio = HasRadio,
            HasSunroof = HasSunroof,
            Period = Period,
            Description = Description,
            Images = Images,
            Longitude = Longitude,
            Latitude = Latitude,
            IsListed = IsListed,
            CreatedAt = CreatedAt,
            UpdatedAt = UpdatedAt,
            OwnerId = OwnerId,
            Owner = Owner
        };
    }
}
