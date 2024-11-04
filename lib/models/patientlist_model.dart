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
    this.id,
    this.patientDetailsSet,
    this.branch,
    this.user,
    this.payment,
    this.name,
    this.phone,
    this.address,
    this.price,
    this.totalAmount,
    this.discountAmount,
    this.advanceAmount,
    this.balanceAmount,
    this.dateNdTime,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    var detailsFromJson = json['patientdetails_set'] as List? ?? [];
    List<PatientDetail> detailsList =
    detailsFromJson.map((i) => PatientDetail.fromJson(i)).toList();

    // Check for branch existence
    Branch? branch =
    json['branch'] != null ? Branch.fromJson(json['branch']) : null;

    return PatientModel(
      id: json['id'],
      patientDetailsSet: detailsList,
      branch: branch,
      user: json['user'] as String?,
      payment: json['payment'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : null,
      totalAmount: (json['total_amount'] != null) ? (json['total_amount'] as num).toDouble() : 0.0,
      discountAmount: (json['discount_amount'] != null) ? (json['discount_amount'] as num).toDouble() : 0.0,
      advanceAmount: (json['advance_amount'] != null) ? (json['advance_amount'] as num).toDouble() : 0.0,
      balanceAmount: (json['balance_amount'] != null) ? (json['balance_amount'] as num).toDouble() : 0.0,
      dateNdTime: json['date_nd_time'] != null
          ? DateTime.parse(json['date_nd_time'])
          : null,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'patientdetails_set': patientDetailsSet?.map((e) => e.toJson()).toList(),
      'branch': branch?.toJson() ?? {},
      'user': user ?? '',
      'payment': payment ?? '',
      'name': name ?? '',
      'phone': phone ?? '',
      'address': address ?? '',
      'price': price ?? 0.0,
      'total_amount': totalAmount ?? 0.0,
      'discount_amount': discountAmount ?? 0.0,
      'advance_amount': advanceAmount ?? 0.0,
      'balance_amount': balanceAmount ?? 0.0,
      'date_nd_time': dateNdTime?.toIso8601String() ?? '',
      'is_active': isActive ?? false,
      'created_at': createdAt?.toIso8601String() ?? '',
      'updated_at': updatedAt?.toIso8601String() ?? '',
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
    this.id,
    this.male,
    this.female,
    this.patient,
    this.treatment,
    this.treatmentName,
  });

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: json['id'] as int?,
      male: json['male'] as String?,
      female: json['female'] as String?,
      patient: json['patient'] as int?,
      treatment: json['treatment'] as int?,
      treatmentName: json['treatment_name'] as String?,
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
