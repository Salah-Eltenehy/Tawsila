namespace Backend.Models.API.CarAPI;

public record GetCarRequest
(
   CarFilterCriteria criteria,
   int total_count,
   int offset,
   int updatedOffset
);

