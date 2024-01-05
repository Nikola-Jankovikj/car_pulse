import 'dart:convert';

class ModificationInfo {
  final String category;
  final String description;
  final double price;

  ModificationInfo({
    required this.category,
    required this.description,
    required this.price,
  });

  ModificationInfo copyWith({
    String? category,
    String? description,
    double? price,
  }) {
    return ModificationInfo(
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'price': price,
    };
  }

  factory ModificationInfo.fromMap(Map<String, dynamic> map) {
    return ModificationInfo(
      category: map['category'],
      description: map['description'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ModificationInfo.fromJson(String source) =>
      ModificationInfo.fromMap(json.decode(source));

  static List<ModificationInfo> listFromJson(String source) {
    Iterable list = json.decode(source);
    return List<ModificationInfo>.from(
        list.map((item) => ModificationInfo.fromMap(item)));
  }

  static String listToJson(List<ModificationInfo> list) {
    List<Map<String, dynamic>> mappedList =
        List<Map<String, dynamic>>.from(list.map((item) => item.toMap()));
    return json.encode(mappedList);
  }

  @override
  String toString() =>
      'ModificationInfo(category: $category, description: $description, price: $price)';
}
