import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../model/ServiceInfo.dart';
import '../model/car.dart';

class CarStorage {
  static const _keyCar = 'carInfo';

  Future<void> saveCarInfo(List<Car> cars) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> carData = cars.map((car) => carToJson(car)).toList();
    await prefs.setStringList(_keyCar, carData);
  }

  Future<List<Car>> getCarInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final carData = prefs.getStringList(_keyCar);
    if (carData != null) {
      return carData.map((data) => carFromJson(data)).toList();
    } else {
      return [];
    }
  }

  String carToJson(Car car) {
    return json.encode(car.toJson());
  }

  Car carFromJson(String data) {
    Map<String, dynamic> carMap = json.decode(data);
    return Car.fromJson(carMap);
  }

  List<Map<String, dynamic>> serviceInfoListToJson(List<ServiceInfo> serviceRecords) {
    return serviceRecords.map((service) => service.toJson()).toList();
  }

  List<ServiceInfo> serviceInfoListFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ServiceInfo.fromJson(json)).toList();
  }
}
