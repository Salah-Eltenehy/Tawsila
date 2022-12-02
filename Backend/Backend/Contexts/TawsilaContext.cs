using Backend.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace Backend.Contexts;

public class TawsilaContext : DbContext
{
    public TawsilaContext(DbContextOptions<TawsilaContext> options) : base(options)
    {
    }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // On Delete should be modified 
        modelBuilder.Entity<Review>()
            .HasOne(p => p.Reviewee)
            .WithMany(p => p.Reviews)
            .HasForeignKey(p => p.RevieweeId)
            .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<Review>()
            .HasOne(p => p.Reviewer)
            .WithMany()
            .HasForeignKey(p => p.ReviewerId)
            .OnDelete(DeleteBehavior.NoAction);
    }

    public DbSet<Car> Cars { get; set; } = null!;
    public DbSet<User> Users { get; set; } = null!;
    public DbSet<Review> Reviews { get; set; } = null!;
}