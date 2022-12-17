using Backend.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace xUnit_Tests.Car_Tests.Service_Tests
{
    public class GetAllCarsTest
    {
        [Fact]
        public async void GetAllCarsTest_ReturnsListOfCars()
        {
            // Arrange
            var mockRepo = new Mock<ICarRepo>();
            var mockUserService = new Mock<IUserService>();
            var carList = Helper.GetCarsList();
            mockRepo.Setup(x => x.GetCars()).ReturnsAsync(carList);
            var carService = new CarService(mockRepo.Object, mockUserService.Object);

            // Act
            var result = await carService.GetCars();

            // Assert
            Assert.NotNull(result);
            Assert.True(carList.IsDeepEqual(result));
        }
    }
}
