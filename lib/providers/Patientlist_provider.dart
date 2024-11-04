import 'dart:convert';
import 'package:ayurvedic_center/models/patientlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config/app_controller.dart';
import '../data/urls.dart';

class PatientProvider with ChangeNotifier {
  List<PatientModel> _patient = [];
  List<PatientModel> _filteredPatients = [];
  bool _isLoading = false;

  List<PatientModel> get patient => _patient;
  List<PatientModel> get filteredPatients => _filteredPatients.isEmpty ? _patient : _filteredPatients;
  bool get isLoading => _isLoading;

  Future<void> getPatientList() async {
    final url = Uri.parse(Urls.patientList);
    print(url);
    String? token = await AppController.getToken();

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        _patient = (data['patient'] as List)
            .map((item) => PatientModel.fromJson(item))
            .toList();
        _filteredPatients = _patient;
      } else {
        print('getPatient failed: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterPatientsByName(String query) {
    if (query.isEmpty) {
      _filteredPatients = _patient;
    } else {
      _filteredPatients = _patient.where((patient) =>
      patient.name?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
    notifyListeners();
  }
}
