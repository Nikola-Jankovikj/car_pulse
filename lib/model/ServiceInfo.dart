import '../enums/CategoryEnum.dart';
import '../enums/ConditionEnum.dart';

class ServiceInfo {
  final DateTime dateService;
  final int odometer;
  final String display;
  final String description;
  final CategoryEnum category;
  final ConditionEnum condition;
  final double price;

  ServiceInfo({
    required this.dateService,
    required this.odometer,
    required this.display,
    required this.description,
    required this.category,
    required this.condition,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateService': dateService.toIso8601String(),
      'odometer': odometer,
      'display': display,
      'description': description,
      'category': category.toString(), // Assuming CategoryEnum is serializable
      'condition': condition.toString(), // Assuming ConditionEnum is serializable
      'price': price,
    };
  }

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(
      dateService: DateTime.parse(json['dateService']),
      odometer: json['odometer'],
      display: json['display'],
      description: json['description'],
      category: getCategoryEnum(json['category']), // Deserialize CategoryEnum
      condition: getConditionEnum(json['condition']), // Deserialize ConditionEnum
      price: json['price'],
    );
  }

  static CategoryEnum getCategoryEnum(String value) {
    return CategoryEnum.values.firstWhere((e) => e.toString() == value);
  }

  static ConditionEnum getConditionEnum(String value) {
    return ConditionEnum.values.firstWhere((e) => e.toString() == value);
  }

  static List<Map<String, dynamic>> serviceInfoListToJson(List<ServiceInfo> serviceRecords) {
    return serviceRecords.map((service) => service.toJson()).toList();
  }

  static List<ServiceInfo> serviceInfoListFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ServiceInfo.fromJson(json)).toList();
  }
}