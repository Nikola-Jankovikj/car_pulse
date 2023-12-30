import '../../model/ServiceInfo.dart';
import '../../model/car.dart';
import '../repository/car_storage.dart';

class CarService {
  final CarStorage _carStorage = CarStorage();

  Future<void> saveCar(Car car) async {
    List<Car> existingCars = await _carStorage.getCarInfo();
    existingCars.add(car);
    await _carStorage.saveCarInfo(existingCars);
  }

  // Future<Car?> loadCar(String make, String model) async {
  //   List<Car> allCars = await _carStorage.getCarInfo();
  //   return allCars.firstWhere(
  //         (car) => car.make == make && car.model == model,
  //     orElse: () => null,
  //   );
  // }

  Future<List<Car>> loadAllCars() async {
    return await _carStorage.getCarInfo();
  }
}
