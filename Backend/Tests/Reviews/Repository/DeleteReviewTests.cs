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
public class DeleteReviewTests : IDisposable
{
    private readonly TawsilaContext _context;
    private readonly ReviewRepo reviewRepo;
    private readonly Review review;
    public DeleteReviewTests()
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
    public async Task ValidDeletion()
    {
        _context.Reviews.Add(review);
        await _context.SaveChangesAsync();
        await reviewRepo.DeleteReview(1);
        var result = await _context.Reviews.FindAsync(1);
        Assert.Null(result);
    }


    [Fact]
    public async Task InvalidDeletion_ThrowsException()
    {
        NotFoundException ex = await Assert.ThrowsAsync<NotFoundException>(() => reviewRepo.DeleteReview(1));
        Assert.Equal("Review not found", ex.Message);
    }
}