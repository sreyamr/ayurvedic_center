import 'package:ayurvedic_center/providers/Patientlist_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientProvider = Provider.of<PatientProvider>(context, listen: false);
      patientProvider.getPatientList();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          // Check if patient list is not empty
          if (patientProvider.patient.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: patientProvider.patient.length,
            itemBuilder: (context, index) {
              final patient = patientProvider.patient[index];
              final firstDetail = patient.patientDetailsSet?.isNotEmpty == true ? patient.patientDetailsSet![0] : null;
              String formattedDate = patient.createdAt != null
                  ? DateFormat('d/MM/yy').format(patient.createdAt!.toLocal())
                  : 'No Date';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(firstDetail?.treatmentName ?? 'No Treatment'),
                      const SizedBox(height: 4.0),
                      Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {

        Navigator.pushNamed(context,AppRoutes.register);
      },
      tooltip: 'Register Now',
      icon: const Icon(Icons.add),
      label: const Text('Register Now'),
    );
  }
}

