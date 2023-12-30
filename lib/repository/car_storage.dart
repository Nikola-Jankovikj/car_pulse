import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../model/ServiceInfo.dart';
import '../model/car.dart';

class CarStorage {
  static const _keyCar = 'carInfo';

  Future<void> saveCarInfo(List<Car> cars) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> carData = cars.map((exam) => carToJson(exam)).toList();
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
    Map<String, dynamic> examMap = {
      'make': car.make,
      'model': car.model,
      'serviceRecords': serviceInfoListToJson(car.serviceRecords),
    };
    return json.encode(examMap);
  }

  Car carFromJson(String data) {
    Map<String, dynamic> carMap = json.decode(data);
    return Car(
      make: carMap['make'],
      model: carMap['model'],
      serviceRecords: serviceInfoListFromJson(carMap['serviceRecords']),
    );
  }

  List<Map<String, dynamic>> serviceInfoListToJson(List<ServiceInfo> serviceRecords) {
    return serviceRecords.map((service) => service.toJson()).toList();
  }

  List<ServiceInfo> serviceInfoListFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ServiceInfo.fromJson(json)).toList();
  }
}
