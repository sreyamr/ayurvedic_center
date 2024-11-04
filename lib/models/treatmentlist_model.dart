import 'branchlist_model.dart';

class Treatment {
  int? id;
  List<Branch>? branches;
  String? name;
  String? duration;
  double? price;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Treatment({
    required this.id,
    required this.branches,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      branches: (json['branches'] as List)
          .map((branchJson) => Branch.fromJson(branchJson))
          .toList(),
      name: json['name'],
      duration: json['duration'],
      price:
          double.tryParse(json['price'].toString()) ?? 0.0, // Parse as double
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branches': branches?.map((branch) => branch.toJson()).toList(),
      'name': name,
      'duration': duration,
      'price': price,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
