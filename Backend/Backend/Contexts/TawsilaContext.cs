using Backend.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Hosting;

namespace Backend.Contexts;

public class TawsilaContext : DbContext
{

    public TawsilaContext(DbContextOptions<TawsilaContext> options) : base(options)
    {
    }

    // Review this 
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Review>()
            .HasOne(p => p.reviewee)
            .WithMany(p => p.reviews)
            .HasForeignKey(p => p.revieweeId)
            .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<Review>()
            .HasOne(p => p.reviewer)
            .WithMany()
            .HasForeignKey(p => p.reviewerId)
            .OnDelete(DeleteBehavior.NoAction);
            
    }

    public DbSet<Car> Cars { get; set; } = null!;
    public DbSet<User> Users { get; set; } = null!;
    public DbSet<Review> Reviews { get; set; } = null!;
}