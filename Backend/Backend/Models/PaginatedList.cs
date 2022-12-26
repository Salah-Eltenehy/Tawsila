using System.ComponentModel.DataAnnotations;

namespace Backend.Models;

public record PaginatedList<T>(
    [Required] T[] Items,
    [Required] int TotalCount,
    [Required] int Offset
);
