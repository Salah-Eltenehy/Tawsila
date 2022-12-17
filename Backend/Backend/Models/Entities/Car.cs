using System.ComponentModel.DataAnnotations;

namespace Backend.Models.Entities;

public class Car 
{
    [Key] public int Id { get; set; }

    [Required] public string Brand { get; set; } = null!;

    [Required] public string Model { get; set; } = null!;

    [Required] public int Year { get; set; }

    [Required] public int Price { get; set; }

    [Required] public int SeatsCount { get; set; }

    [Required] public string Transmission { get; set; } = null!;

    [Required] public string FuelType { get; set; } = null!;

    [Required] public string BodyType { get; set; } = null!;

    [Required] public bool HasAirConditioning { get; set; }

    [Required] public bool HasAbs { get; set; }

    [Required] public bool HasRadio { get; set; }

    [Required] public bool HasSunroof { get; set; }

    [Required] public int Period { get; set; }

    [Required] public string Description { get; set; } = null!;

    //[Required]
    //public string[] images { get; set; }

    [Required] public double Longitude { get; set; }

    [Required] public double Latitude { get; set; }

    [Required] public bool IsListed { get; set; }

    [Required] public DateTime CreatedAt { get; set; }

    [Required] public DateTime UpdatedAt { get; set; }

    public double distanceFromUser { get; set; }

    [Required] public int OwnerId { get; set; }

    public User Owner { get; set; } = null!;

    /*public int CompareTo(Car? car2, int cLatitude, int cLongtide)
    {
        int distanceC1 = (int)Math.Sqrt(Math.Pow(this.Longitude - cLongtide, 2) - Math.Pow(this.Latitude - cLatitude, 2));
        int distanceC2 = (int)Math.Sqrt(Math.Pow(car2.Longitude - cLongtide, 2) - Math.Pow(car2.Latitude - cLatitude, 2));
        if (distanceC1 == distanceC2) return 0;
        else if (distanceC1 > distanceC2) return 1;
        else return -1;
    }*/

}