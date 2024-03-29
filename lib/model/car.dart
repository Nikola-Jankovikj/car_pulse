import 'dart:convert';
import 'package:car_pulse/model/EditInfo.dart';
import 'package:uuid/uuid.dart';
import '../service/notification_service.dart';
import 'ServiceInfo.dart';
import 'ModificationInfo.dart';

class Car {
  final String? id;
  final String make;
  final String model;
  final List<ServiceInfo> serviceRecords;
  final List<ModificationInfo> modificationRecords;
  EditInfo? editRecord;
  String? photoBase64;

  DateTime? lastServiceDate;
  DateTime? upcomingServiceDate;

  static const String defaultPhotoBase64 =
      'iVBORw0KGgoAAAANSUhEUgAAAoAAAAGqCAAAAAC+eaoyAAAACXBIWXMAAA7zAAAO8wEcU5k6AAAAEXRFWHRUaXRsZQBQREYgQ3JlYXRvckFevCgAAAATdEVYdEF1dGhvcgBQREYgVG9vbHMgQUcbz3cwAAAALXpUWHREZXNjcmlwdGlvbgAACJnLKCkpsNLXLy8v1ytISdMtyc/PKdZLzs8FAG6fCPGXryy4AAAbVElEQVQYGe3BwXocR5Kl0f+ae0SCqppFv//r1W4W8810lQhkhNvtBANUCxRIQuxReQC0c/QPSpknKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglIm6pQ/QQiDjTiYPyclBBiBsRVgBALbwc+lU15NoEjSSAIEJN8mDubQhDAWj0xIGDuwkDA/l055FYENHiCJm8x0mj8ppAhJiSTAAiMwBvGz6ZTXkm0ymhh7pjNHps23iYM5jLiR1BUtQqQEknYEJMHPpVNexUgyljy263UYY7D4NnMQB2cCdotoEboJKSL0yGl+Mp3yKikQsOV+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zOyIRym1tqwtAIPFuVkgpL/1hxwoUsJOB0LAiNYvd928M503LnVp7X7LwCDFjpBgb72vy9ISgW3xnDiYs7AgvKht18zEYIQl8LD6uqyLbN6XzhtntZv7zTdSZ4DBLH1dewsEmDdC1s4SYrONiNDmAUjr5a4Jm3em88Z1rB593OeeCQiFJC5t6cIZYEB8wZyLwEKMaL2vW957pFO0TEdfWr8sZIJ4XzpvnGxLq/vY95GZllqLiEtE2AZzI85OgIEWUvQ1wzly2B9sWu9NTWnen84bNxCJdJdOZyaKR+wijWReZg7iHGQ+CacJuAhIG7UIgZxDQfLO6B+8D+I5AwIlb5M4mPet804kh+BggcGUU+u8UwJzI94m83PovBPBczIy5ew675V4ZMqpdd6J5BD8NxlRTq3zTplPZN4mcxDvW+edCJ5LgcCUU+u8E+a54G0TP4eglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZqPPOiOfMQbzMlJmCUiYKSpkoKGWioJSJglImCkqZKChlos6/iXgdcxB/jjmYl5lyRkEpEwWlTBSUMlHnZET5mQSlTBSUMlFQykSdfzPz/4c4mPKWBaVMFJQyUVDKRJ03ypT3IChloqCUiYJSJur8m5hS/igoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaKglImCUiYKSpkoKGWioJSJglImCkqZKChloqCUiYJSJgpKmSgoZaL/An5ln++LEFccAAAAAElFTkSuQmCC';

  Car({
    String? id,
    required this.make,
    required this.model,
    List<ServiceInfo>? serviceRecords,
    List<ModificationInfo>? modificationRecords,
    this.editRecord,
    this.lastServiceDate,
    this.upcomingServiceDate,
    String? photoBase64,
  })  : serviceRecords = serviceRecords ?? [],
        modificationRecords = modificationRecords ?? [],
        photoBase64 = photoBase64 ?? defaultPhotoBase64,
        id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'serviceRecords': serviceRecords.map((record) => record.toJson()).toList(),
      'modificationRecords': modificationRecords.map((record) => record.toJson()).toList(),
      'editRecord': editRecord?.toJson(),
      'photoBase64': photoBase64,
      'lastServiceDate': lastServiceDate?.toString(),
      'upcomingServiceDate': upcomingServiceDate?.toString(),
    };
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      serviceRecords: (json['serviceRecords'] as List<dynamic>?)
          ?.map((recordJson) => ServiceInfo.fromJson(recordJson))
          .toList() ??
          [],
      modificationRecords: (json['modificationRecords'] as List<dynamic>?)
          ?.map((recordJson) => ModificationInfo.fromJson(recordJson))
          .toList() ??
          [],
      editRecord: json['editRecord'] != null ? EditInfo.fromJson(json['editRecord']) : null,
      photoBase64: json['photoBase64'],
      lastServiceDate: json['lastServiceDate'] != null ? DateTime.parse(json['lastServiceDate']) : null,
      upcomingServiceDate: json['upcomingServiceDate'] != null ? DateTime.parse(json['upcomingServiceDate']) : null,
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory Car.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Car.fromJson(json);
  }

  void setNextServiceDate() {

    // Schedule or update notification
    if (upcomingServiceDate != null) {
      if (id != null) {
        // If the car has an ID, it means it already has a scheduled notification
        NotificationService.updateNotification(
          id!.hashCode,
          upcomingServiceDate!,
          this
        );
      } else {
        // If the car doesn't have an ID, it's a new car, so schedule a new notification
        NotificationService.scheduleNotification(
          id!.hashCode,
          make,
          model,
          upcomingServiceDate!,
        );
      }
    }
  }
}
