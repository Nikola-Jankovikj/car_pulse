import 'package:shared_preferences/shared_preferences.dart';

import '../model/car.dart';

class CarStorage {
  static const _keyCar = 'carInfo';

  Future<void> saveCarInfo(List<Car> cars) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> carData = cars.map((data) => data.carToJson()).toList();
    await prefs.setStringList(_keyCar, carData);
  }

  Future<List<Car>> getCarInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final carData = prefs.getStringList(_keyCar);
    if (carData != null) {
      return carData.map((data) => Car.carFromJson(data)).toList();
    } else {
      return [];
    }
  }
}
