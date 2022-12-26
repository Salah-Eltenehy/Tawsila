using Backend.Contexts;
using Backend.Models.Entities;
using Backend.Models.Exceptions;
using Backend.Repositories;
using Microsoft.EntityFrameworkCore;
using NuGet.Frameworks;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tests.Reviews;
using Tests.Reviews.Controller;

namespace Tests.Cars.Repository;
public class UpdateReviewTests : IDisposable
{
    private readonly TawsilaContext _context;
    private readonly ReviewRepo reviewRepo;
    private readonly Review review;
    public UpdateReviewTests()
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
    public async Task ValidUpdate()
    {
        _context.Reviews.Add(review);
        await _context.SaveChangesAsync();
        var req = ReviewHelper.GetTestUpdateReviewRequest();
        await reviewRepo.UpdateReview(1, req);
        var result = await _context.Reviews.FindAsync(1);
        Assert.NotNull(result); 
        Assert.Equal(result.Comment, req.Comment);
        Assert.Equal(result.Rating, req.Rating);
    }

    [Fact]
    public async Task InvalidUpdate_ThrowsException()
    {
        var req = ReviewHelper.GetTestUpdateReviewRequest();
        NotFoundException ex = await Assert.ThrowsAsync<NotFoundException>(() => reviewRepo.UpdateReview(1, req));
        Assert.Equal("Review not found", ex.Message);
    }
}