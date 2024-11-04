import 'package:flutter/material.dart';
import '../config/routes.dart';
import '../models/user_model.dart';
import '../providers/login_providers.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 4),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/logo1.png',
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Login Or Register To Book Your Appointments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildTextField("Email", emailController),
            const SizedBox(height: 20),
            buildTextField("Password", passwordController, isPassword: true),
            const SizedBox(height: 40),
            buildLoginButton(context),
            const SizedBox(height: 130),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                children: const <TextSpan>[
                  TextSpan(
                    text: "By creating or logging into an account, you are agreeing to our ",
                  ),
                  TextSpan(
                    text: "Terms and Conditions ",
                    style: TextStyle(color: Colors.indigo),
                  ),
                  TextSpan(
                    text: "and ",
                  ),
                  TextSpan(
                    text: "Privacy Policy.",
                    style: TextStyle(color: Colors.indigo),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
     // obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              final userModel = UserModel(username: emailController.text, password: passwordController.text);
              await loginProvider.loginUser(userModel);

              if (loginProvider.loginSuccess) {
                Navigator.pushNamed(context, AppRoutes.home);
              } else {
                final errorMessage = loginProvider.errorMessage ?? 'Login failed. Please try again.';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade900,
            ),
            child: Text("Submit", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
          ),
        );
      },
    );
  }
}
