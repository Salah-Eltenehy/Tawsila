using Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace Backend.Contexts;

public class TawsilaContext : DbContext
{
    public TawsilaContext(DbContextOptions<TawsilaContext> options) : base(options)
    {
    }

    public DbSet<Car> Cars { get; set; } = null!;
    public DbSet<User> Users { get; set; } = null!;
    public DbSet<Review> Reviews { get; set; } = null!;
}