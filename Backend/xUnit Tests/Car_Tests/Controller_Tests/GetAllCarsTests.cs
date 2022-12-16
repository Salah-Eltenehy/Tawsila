using Backend.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DeepEqual.Syntax;

namespace xUnit_Tests.Car_Tests.Controller_Tests
{
    public class GetAllCarsTest
    {
        [Fact]
        public async void GetAllCarsTest_ReturnsListOfCars()
        {
            // Arrange
            var controllerContext = Helper.GetTestIdentity();
            var mockService = new Mock<ICarService>();
            var carList = Helper.GetCarsList();
            mockService.Setup(x => x.GetCars()).ReturnsAsync(carList);
            var carController = new CarsController(mockService.Object)
            {
                ControllerContext = controllerContext,
            };

            // Act
            var result = await carController.GetCars();

            // Assert
            Assert.NotNull(result);
            Assert.NotNull(result.Value);
            Assert.True(carList.Value.IsDeepEqual(result.Value));
        }
    }
}
