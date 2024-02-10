import 'dart:ffi';

import 'package:car_pulse/enums/FuelType.dart';

class EditInfo {
  final String engine;
  final double hp;
  final double torque;
  final FuelType fuelType;
  final double zeroToHundred;
  final int maxSpeed;
  final int kerbWeight;
  final String tireSize;

  EditInfo({
    this.engine = 'Default Engine',
    this.hp = 0.0,
    this.torque = 0,
    this.fuelType = FuelType.Petrol,
    this.zeroToHundred = 0,
    this.maxSpeed = 0,
    this.kerbWeight = 0,
    this.tireSize = 'Default Tire Size',
  });

  Map<String, dynamic> toJson() {
    return {
      'engine': engine,
      'hp': hp,
      'torque': torque,
      'fuelType': fuelType.toString(),
      'zeroToHundred': zeroToHundred,
      'maxSpeed': maxSpeed,
      'kerbWeight': kerbWeight,
      'tireSize': tireSize
    };
  }

  factory EditInfo.fromJson(Map<String, dynamic> json) {
    return EditInfo(
        engine: json['engine'],
        hp: json['hp'],
        torque: json['torque'],
        fuelType: getFuelType(json['fuelType']),
        zeroToHundred: json['zeroToHundred'],
        maxSpeed: json['maxSpeed'],
        kerbWeight: json['kerbWeight'],
        tireSize: json['tireSize']);
  }

  static FuelType getFuelType(String value) {
    return FuelType.values.firstWhere((e) => e.toString() == value);
  }

  // static List<Map<String, dynamic>> EditInfoListToJson(
  //     List<EditInfo> editRecords) {
  //   return editRecords.map((edit) => edit.toJson()).toList();
  // }
  //
  // static List<EditInfo> serviceInfoListFromJson(List<dynamic> jsonList) {
  //   return jsonList.map((json) => EditInfo.fromJson(json)).toList();
  // }

// Convert a single EditInfo object to JSON
  Map<String, dynamic> toMap() {
    return {
      'engine': engine,
      'hp': hp,
      'torque': torque,
      'fuelType': fuelType.toString(),
      'zeroToHundred': zeroToHundred,
      'maxSpeed': maxSpeed,
      'kerbWeight': kerbWeight,
      'tireSize': tireSize
    };
  }

  // Create an EditInfo object from a JSON map
  factory EditInfo.fromMap(Map<String, dynamic> map) {
    return EditInfo(
      engine: map['engine'],
      hp: map['hp'],
      torque: map['torque'],
      fuelType: getFuelType(map['fuelType']),
      zeroToHundred: map['zeroToHundred'],
      maxSpeed: map['maxSpeed'],
      kerbWeight: map['kerbWeight'],
      tireSize: map['tireSize'],
    );
  }
}
