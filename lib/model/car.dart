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

  Map<String, dynamic> toJson() {
    return {
      'make': make,
      'model': model,
      'serviceRecords': serviceRecords.map((record) => record.toJson()).toList(),
    };
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      make: json['make'],
      model: json['model'],
      serviceRecords: (json['serviceRecords'] as List<dynamic>?)
          ?.map((recordJson) => ServiceInfo.fromJson(recordJson))
          .toList() ??
          [], // Deserialize ServiceInfo objects from JSON
    );
  }


  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory Car.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Car.fromJson(json);
  }

}
