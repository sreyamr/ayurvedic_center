class Branch {
  final int id;
  final String name;
  final int patientsCount;
  final String location;
  final List<String> phones;
  final String mail;
  final String address;
  final String gst;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.patientsCount,
    required this.location,
    required this.phones,
    required this.mail,
    required this.address,
    required this.gst,
    required this.isActive,
  });


  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      patientsCount: json['patients_count'],
      location: json['location'],
      phones: (json['phone'] as String).split(',').map((phone) => phone.trim()).toList(),
      mail: json['mail'],
      address: json['address'],
      gst: json['gst'] ?? '',
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'patients_count': patientsCount,
      'location': location,
      'phone': phones.join(','),
      'mail': mail,
      'address': address,
      'gst': gst,
      'is_active': isActive,
    };
  }
}
