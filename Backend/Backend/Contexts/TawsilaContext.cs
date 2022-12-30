using Backend.Models.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Backend.Contexts;

public class TawsilaContext : DbContext
{
    public TawsilaContext(DbContextOptions<TawsilaContext> options) : base(options) { }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>()
            .HasIndex(u => new { u.Email })
            .IsUnique();
        modelBuilder.Entity<Car>()
            .Property(e => e.Images)
            .HasConversion(
                v => string.Join(',', v),
                v => v.Split(',', StringSplitOptions.RemoveEmptyEntries),
                new ValueComparer<string[]>(
                    (c1, c2) => c1!.SequenceEqual(c2!),
                    c => c.Aggregate(0, (a, v) => HashCode.Combine(a, v.GetHashCode())),
                    c => c.ToArray()));
        modelBuilder
            .Entity<Review>()
            .HasOne(p => p.Reviewee)
            .WithMany(p => p.Reviews)
            .HasForeignKey(p => p.RevieweeId)
            .OnDelete(DeleteBehavior.NoAction);

        modelBuilder
            .Entity<Review>()
            .HasOne(p => p.Reviewer)
            .WithMany()
            .HasForeignKey(p => p.ReviewerId)
            .OnDelete(DeleteBehavior.NoAction);
    }

    public DbSet<Car> Cars { get; set; } = null!;
    public DbSet<User> Users { get; set; } = null!;
    public DbSet<Review> Reviews { get; set; } = null!;
}
