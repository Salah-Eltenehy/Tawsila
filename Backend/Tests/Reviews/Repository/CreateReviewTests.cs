using Backend.Contexts;
using Backend.Models.Entities;
using Backend.Repositories;
using Microsoft.EntityFrameworkCore;

namespace Tests.Cars.Repository;
public class CreateReviewTests : IDisposable
{
    private readonly TawsilaContext _context;
    private readonly ReviewRepo reviewRepo;
    private readonly Review review;
    public CreateReviewTests()
    {
        var options = new DbContextOptionsBuilder<TawsilaContext>()
            .UseInMemoryDatabase(databaseName: "TawsilaDB")
            .Options;
        _context = new TawsilaContext(options);
        reviewRepo = new ReviewRepo(_context);
        review = new Review
        {

            Rating = 5,
            Comment = "Great service",
            RevieweeId = 2,
            ReviewerId = 1
        };
    }

    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _context.Dispose();
    }

    [Fact]
    public async Task ValidReview()
    {
        await reviewRepo.CreateReview(review);
        var result = await _context.Reviews.FindAsync(1);
        
        review.WithDeepEqual(result)
            .IgnoreSourceProperty(x => x!.Id)
            .IgnoreSourceProperty(x => x!.CreatedAt)
            .IgnoreSourceProperty(x => x!.UpdatedAt)
            .Assert();
    }
}