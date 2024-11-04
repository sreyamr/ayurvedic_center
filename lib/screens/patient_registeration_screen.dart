import 'package:ayurvedic_center/providers/branch_list.dart';
import 'package:ayurvedic_center/providers/treatment_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/branchlist_model.dart';
import '../models/patientlist_model.dart';
import '../providers/register_patient.dart';

enum PaymentMethod { cash, card, upi }

class Registration extends StatefulWidget {
  Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountAmountController =
      TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();
  TextEditingController treatmentDateController = TextEditingController();

  final List<String> staticLocations = [
    "Calicut",
    "Wayanad",
    "Kochi",
    "Idukki",
  ];

  String? selectedLocation;
  List<String> selectedTreatmentNames = [];
  Branch? selectedBranch;
  String? _selectedPaymentMethod = "Cash";
  String? selectedTreatment;
  int maleCount = 0;
  int femaleCount = 0;
  List<PatientDetail> patientDetailsList = [];

  @override
  void initState() {
    super.initState();
    final branchList = Provider.of<BranchList>(context, listen: false);
    branchList.getBranchList();
    final treatmentList = Provider.of<TreatmentList>(context, listen: false);
    treatmentList.getTreatmentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildInputField(
                    context, "Name", nameController, "Enter your name"),
                buildInputField(context, "WhatsApp Number", whatsappController,
                    "Enter your WhatsApp number", isNumber: true,),
                buildInputField(context, "Address", addressController,
                    "Enter your address"),
                buildLocationDropdown(context),
                buildBranchDropdown(context),
                buildPatientDetails(),
                buildAddTreatmentButton(context),
                buildInputField(context, "Total Amount", totalAmountController,
                    "Enter total amount", isNumber: true,),
                buildInputField(context, "Discount Amount",
                    discountAmountController, "Enter discount amount", isNumber: true,),
                buildPaymentMode(context),
                buildInputField(context, "Advance Amount",
                    advanceAmountController, "Enter advance amount", isNumber: true,),
                buildInputField(context, "Balance Amount",
                    balanceAmountController, "Enter balance amount", isNumber: true,),
                buildTreatMentDate(),
                const SizedBox(
                  height: 20,
                ),
                buildButton(context),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// buildInputField
  Widget buildInputField(BuildContext context, String label,
      TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }


  /// buildLocationDropdown
  Widget buildLocationDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            "Location",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: selectedLocation,
          hint: const Text("Select a location"),
          items: staticLocations.map((String location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedLocation = newValue;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  ///  buildBranchDropdown
  Widget buildBranchDropdown(BuildContext context) {
    final branchProvider = Provider.of<BranchList>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Branch",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            DropdownButtonFormField<Branch>(
              value: branchProvider.branches.contains(selectedBranch) ? selectedBranch : null,
              hint: const Text("Select a branch"),
              items: branchProvider.branches.map((branch) {
                return DropdownMenuItem<Branch>(
                  value: branch,
                  child: Text(branch.name ?? 'Unnamed Branch'),
                );
              }).toList(),
              onChanged: branchProvider.isBranchLoading
                  ? null
                  : (Branch? newBranch) {
                setState(() {
                  selectedBranch = newBranch;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            if (branchProvider.isBranchLoading)
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }


  /// buildTreatmentDropdown
  Widget buildTreatmentDropdown(BuildContext context) {
    final treatmentProvider = Provider.of<TreatmentList>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Treatment",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Stack(
          children: [
            Container(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                value: null,
                hint: Text(selectedTreatmentNames.isEmpty
                    ? "Select a treatment"
                    : selectedTreatmentNames.join(", ")),
                items: treatmentProvider.treatments.map((treatment) {
                  return DropdownMenuItem<String>(
                    value: treatment.name,
                    child: Text(treatment.name.toString()),
                  );
                }).toList(),
                onChanged: treatmentProvider.isTreatmentLoading
                    ? null
                    : (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      // Add or remove treatment name from the list
                      if (selectedTreatmentNames.contains(newValue)) {
                        selectedTreatmentNames.remove(newValue);
                      } else {
                        selectedTreatmentNames.add(newValue);
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            if (treatmentProvider.isTreatmentLoading)
              Container(
                height: 56.0,
                alignment: Alignment.centerRight,
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ],
    );
  }

  /// buildPaymentMode
  Widget buildPaymentMode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Payment Method",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Cash radio button
            Row(
              children: [
                Radio<String>(
                  value: "Cash",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                const Text("Cash"),
              ],
            ),
            const SizedBox(width: 16.0),

            // Card radio button
            Row(
              children: [
                Radio<String>(
                  value: "Card",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                const Text("Card"),
              ],
            ),
            const SizedBox(width: 16.0),

            // UPI radio button
            Row(
              children: [
                Radio<String>(
                  value: "UPI",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                const Text("UPI"),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// buildTreatMentDate
  Widget buildTreatMentDate() {
    return TextField(
      controller: treatmentDateController,
      decoration: InputDecoration(
        labelText: "Treatment Date",
        hintText: "Select a date",
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      readOnly: true,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        treatmentDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  /// buildButton
  Widget buildButton(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () => _savePatient(context),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: const Text('Save', style: TextStyle(fontSize: 16.0)),
      ),
    );
  }

  /// _savePatient
  Future<void> _savePatient(BuildContext context) async {
    final patient = PatientModel(
      name: nameController.text,
      phone: whatsappController.text,
      address: addressController.text,
      branch: selectedBranch,
      payment: _selectedPaymentMethod,
      user:nameController.text,
      patientDetailsSet: patientDetailsList,
      totalAmount: double.tryParse(totalAmountController.text) ?? 0.0,
      discountAmount: double.tryParse(discountAmountController.text) ?? 0.0,
      advanceAmount: double.tryParse(advanceAmountController.text) ?? 0.0,
      balanceAmount: double.tryParse(balanceAmountController.text) ?? 0.0,
    );

    final addPatientProvider = Provider.of<AddPatient>(context, listen: false);
    await addPatientProvider.addPatient(patient);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        addPatientProvider.addSuccess
            ? 'Patient added successfully'
            : 'Failed to add patient: ${addPatientProvider.errorMessage}',
      )),
    );
  }

  ///buildAddTreatmentButton
  Widget buildAddTreatmentButton(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AddTreatmentSheet(
                      context, setState);
                },
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Add Treatment',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

/// AddTreatmentSheet
  Widget AddTreatmentSheet(BuildContext context, StateSetter setState) {
    final theme = Theme.of(context);
    final addPatientProvider = Provider.of<AddPatient>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTreatmentDropdown(context), // Uses the treatment dropdown
          const SizedBox(height: 20),
          Text(
            'Add Patients',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Male',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: theme.primaryColor),
                    onPressed: () {
                      setState(() {
                        if (maleCount > 0) maleCount--;
                      });
                    },
                  ),
                  Text(
                    '$maleCount',
                    style: theme.textTheme.bodyLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: theme.primaryColor),
                    onPressed: () {
                      setState(() {
                        maleCount++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Female',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: theme.primaryColor),
                    onPressed: () {
                      setState(() {
                        if (femaleCount > 0) femaleCount--;
                      });
                    },
                  ),
                  Text(
                    '$femaleCount',
                    style: theme.textTheme.bodyLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: theme.primaryColor),
                    onPressed: () {
                      setState(() {
                        femaleCount++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              PatientDetail patientDetail = PatientDetail(
                male: maleCount.toString(),
                female: femaleCount.toString(),
                patient: maleCount + femaleCount,
                treatmentName: selectedTreatmentNames.isNotEmpty
                    ? selectedTreatmentNames.join(", ")
                    : null,
              );
              addPatientProvider.addTreatment(patientDetail);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(
              'Save',
              style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

/// buildPatientDetails
  Widget buildPatientDetails() {
    return SizedBox(
      height: 100,
      child: Consumer<AddPatient>(
        builder: (context, addPatientProvider, child) {
          if (addPatientProvider.patientDetailsList.isEmpty) {

            return SizedBox(
              child: Center(
                child: Text(
                  'No patient details available.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: addPatientProvider.patientDetailsList.length,
            itemBuilder: (context, index) {
              final patientDetail = addPatientProvider.patientDetailsList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${index + 1}. ',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    patientDetail.treatmentName ?? "No treatment name",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text('Male', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    patientDetail.male ?? "0",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text('Female', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    patientDetail.female ?? "0",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () {

                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              addPatientProvider.removePatientDetail(patientDetail);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
