import 'dart:convert';
import 'ServiceInfo.dart';

class Car {
  final String make;
  final String model;
  final List<ServiceInfo> serviceRecords;

  Car({
    required this.make,
    required this.model,
    List<ServiceInfo>? serviceRecords,
  }) : serviceRecords = serviceRecords ?? [];

  String carToJson() {
    Map<String, dynamic> carMap = {
      'make': make,
      'model': model,
      'serviceRecords': ServiceInfo.serviceInfoListToJson(serviceRecords),
    };
    return json.encode(carMap);
  }

  factory Car.carFromJson(String data) {
    Map<String, dynamic> carMap = json.decode(data);
    return Car(
      make: carMap['make'],
      model: carMap['model'],
      serviceRecords: ServiceInfo.serviceInfoListFromJson(carMap['serviceRecords']),
    );
  }
}