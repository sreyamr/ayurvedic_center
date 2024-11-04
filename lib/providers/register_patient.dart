import 'dart:convert';
import 'package:ayurvedic_center/models/patientlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config/app_controller.dart';
import '../data/urls.dart';
import '../models/user_model.dart';

class AddPatient with ChangeNotifier {
  PatientModel? _patientModel;
  bool _addSuccess = false;
  String? _errorMessage;
  List<PatientDetail> _patientDetailsList = []; // Store the list of patient details

  PatientModel? get patientModel => _patientModel;
  bool get addSuccess => _addSuccess;
  String? get errorMessage => _errorMessage;
  List<PatientDetail> get patientDetailsList => _patientDetailsList; // Expose the patient details list

  Future<void> addPatient(PatientModel patient) async {
    final url = Uri.parse(Urls.addPatient);
    print(url);
    String? token = await AppController.getToken();
    try {
      var jsonData = patient.toJson();
      print(jsonData);
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
        body: json.encode(jsonData), // Ensure you're encoding the JSON
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        String token = data['token'];
        await AppController.saveToken(token);
        _addSuccess = true;
      } else {
        print('Add Patient failed: ${response.body}');
        _addSuccess = false;
      }
      notifyListeners();
    } catch (e) {
      print('An error occurred: $e');
      _addSuccess = false;
      notifyListeners();
    }
  }

  void addTreatment(PatientDetail patientDetail) {
    _patientDetailsList.add(patientDetail);
    notifyListeners(); // Notify listeners about the change
  }
  void removePatientDetail(PatientDetail patientDetail) {
    patientDetailsList.remove(patientDetail);
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}


