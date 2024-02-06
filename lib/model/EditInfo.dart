import 'package:car_pulse/enums/FuelType.dart';

class EditInfo {
  final String engine;
  final int hp;
  final int torque;
  final FuelType fuelType;
  final int zeroToHundred;
  final int maxSpeed;
  final int kerbWeight;
  final String tireSize;

  EditInfo(
      {required this.engine,
      required this.hp,
      required this.torque,
      required this.fuelType,
      required this.zeroToHundred,
      required this.maxSpeed,
      required this.kerbWeight,
      required this.tireSize});

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

  static List<Map<String, dynamic>> EditInfoListToJson(
      List<EditInfo> editRecords) {
    return editRecords.map((edit) => edit.toJson()).toList();
  }

  static List<EditInfo> serviceInfoListFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => EditInfo.fromJson(json)).toList();
  }
}
