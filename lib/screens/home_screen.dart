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
    final searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientProvider = Provider.of<PatientProvider>(context, listen: false);
      patientProvider.getPatientList();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by patient name',
                prefixIcon: const Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (value) {
                final patientProvider = Provider.of<PatientProvider>(context, listen: false);
                patientProvider.filterPatientsByName(value);
              },
            ),
          ),
        ),
      ),

      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await patientProvider.getPatientList();
            },
            child: patientProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : patientProvider.filteredPatients.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty_list.png',
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No patients found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: patientProvider.filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = patientProvider.filteredPatients[index];
                final firstDetail = patient.patientDetailsSet?.isNotEmpty == true ? patient.patientDetailsSet![0] : null;
                String formattedDate = patient.createdAt != null
                    ? DateFormat('dd/MM/yyyy').format(patient.createdAt!.toLocal())
                    : 'No Date';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    title: Row(
                      children: [
                        Text(
                          '${index + 1}.', // Serial number
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            patient.name ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstDetail?.treatmentName ?? 'No Treatment',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.calendar_month, color: Colors.red.shade300, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.supervisor_account, color: Colors.red.shade300, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              patient.user ?? 'No User',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "View Booking details",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address: ${patient.address ?? 'No Address'}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Ph: ${patient.phone ?? 'No Name'}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  ///buildFloatingActionButton
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.register);
      },
      tooltip: 'Register Now',
      icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      label: Text(
        'Register Now',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
