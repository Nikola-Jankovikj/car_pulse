import '../../model/ServiceInfo.dart';
import '../../model/car.dart';
import '../repository/car_storage.dart';

class CarService {
  final CarStorage _carStorage = CarStorage();

  Future<void> saveCar(Car car) async {
    List<Car> existingCars = await _carStorage.getCarInfo();

    // Check if the car already exists in the list
    final existingCarIndex = existingCars.indexWhere(
          (existingCar) => existingCar.id == car.id,
    );

    if (existingCarIndex != -1) {
      // Update the existing car
      existingCars[existingCarIndex] = car;
    } else {
      // Add the new car to the list
      existingCars.add(car);
    }

    // Save the updated list to storage
    await _carStorage.saveCarInfo(existingCars);
  }

  Future<List<Car>> loadAllCars() async {
    return await _carStorage.getCarInfo();
  }

  Future<Car> loadCar(String carId) async {
    List<Car> cars = await _carStorage.getCarInfo();
    return cars.firstWhere((car) => car.id == carId);
  }

}
