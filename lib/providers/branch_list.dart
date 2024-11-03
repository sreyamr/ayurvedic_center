import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config/app_controller.dart';
import '../data/urls.dart';
import '../models/branchlist_model.dart';

class BranchList with ChangeNotifier {
  List<Branch> _branches = [];
  bool _isLoading = false;

  List<Branch> get branches => _branches;
  bool get isBranchLoading => _isLoading;

  Future<void> getBranchList() async {
    final url = Uri.parse(Urls.branchList);
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
        _branches = (data['branches'] as List)
            .map((branchJson) => Branch.fromJson(branchJson))
            .toList();
        notifyListeners();
      } else {
        print('getBranchList failed: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
