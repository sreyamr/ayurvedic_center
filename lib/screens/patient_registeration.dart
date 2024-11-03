import 'package:ayurvedic_center/providers/branch_list.dart';
import 'package:ayurvedic_center/providers/treatment_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController discountAmountController = TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();
  final TextEditingController treatmentDateController = TextEditingController();

  final List<String> staticLocations = [
    "Calicut",
    "Wayanad",
    "Kochi",
    "Idukki",
  ];

  String? selectedLocation;
  String? selectedTreatment;
  String? selectedBranch;

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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildInputField(context, "Name", nameController, "Enter your name"),
                buildInputField(context, "WhatsApp Number", whatsappController, "Enter your WhatsApp number"),
                buildInputField(context, "Address", addressController, "Enter your address"),
                buildLocationDropdown(context),
                buildBranchDropdown(context),
                buildInputField(context, "Total Amount", totalAmountController, "Enter total amount"),
                buildInputField(context, "Discount Amount", discountAmountController, "Enter discount amount"),
                buildInputField(context, "Advance Amount", advanceAmountController, "Enter advance amount"),
                buildInputField(context, "Balance Amount", balanceAmountController, "Enter balance amount"),
                buildInputField(context, "Treatment Date", treatmentDateController, "Enter treatment date"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(BuildContext context, String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
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
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget buildLocationDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
        branchProvider.isBranchLoading
            ? const CircularProgressIndicator()
            : DropdownButtonFormField<String>(
          value: selectedBranch,
          hint: const Text("Select a branch"),
          items: branchProvider.branches.map((branch) {
            return DropdownMenuItem<String>(
              value: branch.id.toString(),
              child: Text(branch.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedBranch = newValue;
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

  Widget buildTreatmentDropdown(BuildContext context) {
    final treatmentProvider = Provider.of<TreatmentList>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Treatment",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            ),
          ),
        ),
        treatmentProvider.isTreatmentLoading
            ? const CircularProgressIndicator()
            : DropdownButtonFormField<String>(
          value: selectedTreatment,
          hint: const Text("Select a treatment"),
          items: treatmentProvider.treatments.map((treatment) {
            return DropdownMenuItem<String>(
              value: treatment.id.toString(),
              child: Text(treatment.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedTreatment = newValue; // Update selectedTreatment
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
}
