import 'branchlist_model.dart';

class PatientModel {
  int? id;
  List<PatientDetail>? patientDetailsSet;
  Branch? branch;
  String? user;
  String? payment;
  String? name;
  String? phone;
  String? address;
  double? price;
  double? totalAmount;
  double? discountAmount;
  double? advanceAmount;
  double? balanceAmount;
  DateTime? dateNdTime;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  PatientModel({
    required this.id,
    required this.patientDetailsSet,
    required this.branch,
    required this.user,
    required this.payment,
    required this.name,
    required this.phone,
    required this.address,
    this.price,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    this.dateNdTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    // Safely access patientdetails_set
    var detailsFromJson = json['patientdetails_set'] as List? ?? [];
    List<PatientDetail> detailsList = detailsFromJson.map((i) => PatientDetail.fromJson(i)).toList();

    // Check for branch existence
    Branch? branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;

    return PatientModel(
      id: json['id'],
      patientDetailsSet: detailsList,
      branch: branch,
      user: json['user'],
      payment: json['payment'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      price: json['price'] != null ? json['price'].toDouble() : null,
      totalAmount: json['total_amount']?.toDouble() ?? 0.0,
      discountAmount: json['discount_amount']?.toDouble() ?? 0.0,
      advanceAmount: json['advance_amount']?.toDouble() ?? 0.0,
      balanceAmount: json['balance_amount']?.toDouble() ?? 0.0,
      dateNdTime: json['date_nd_time'] != null ? DateTime.parse(json['date_nd_time']) : null,
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientdetails_set': patientDetailsSet?.map((e) => e.toJson()).toList(),
      'branch': branch?.toJson(),
      'user': user,
      'payment': payment,
      'name': name,
      'phone': phone,
      'address': address,
      'price': price,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'advance_amount': advanceAmount,
      'balance_amount': balanceAmount,
      'date_nd_time': dateNdTime?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class PatientDetail {
  int? id;
  String? male;
  String? female;
  int? patient;
  int? treatment;
  String? treatmentName;

  PatientDetail({
    required this.id,
    required this.male,
    required this.female,
    required this.patient,
    required this.treatment,
    required this.treatmentName,
  });

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: json['id'],
      male: json['male'],
      female: json['female'],
      patient: json['patient'],
      treatment: json['treatment'],
      treatmentName: json['treatment_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'male': male,
      'female': female,
      'patient': patient,
      'treatment': treatment,
      'treatment_name': treatmentName,
    };
  }
}
