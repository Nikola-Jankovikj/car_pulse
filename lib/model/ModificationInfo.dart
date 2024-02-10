class ModificationInfo {
  final String category;
  final String description;
  final double price;

  ModificationInfo({
    required this.category,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'description': description,
      'price': price,
    };
  }

  factory ModificationInfo.fromJson(Map<String, dynamic> json) {
    return ModificationInfo(
      category: json['category'],
      description: json['description'],
      price: json['price'],
    );
  }

  static List<Map<String, dynamic>> ModificaticationInfoListToJson(
      List<ModificationInfo> modificationRecords) {
    return modificationRecords
        .map((modification) => modification.toJson())
        .toList();
  }

  static List<ModificationInfo> ModificationInfoListFromJson(
      List<dynamic> jsonList) {
    return jsonList.map((json) => ModificationInfo.fromJson(json)).toList();
  }
}
