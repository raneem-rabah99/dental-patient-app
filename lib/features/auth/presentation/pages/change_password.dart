import 'package:dentaltreatment/features/auth/presentation/pages/login_page.dart';
import 'package:dentaltreatment/features/auth/presentation/widgets/password.dart';
import 'package:dentaltreatment/features/auth/presentation/widgets/signupWidgit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackground2(),
          Positioned(
            left: 16,
            top: 16,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 8), // Space between icon and text
                  Text(
                    "Change Password", // Your text here
                    style: TextStyle(
                      fontFamily: 'Serif',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: buildFormContainer()),
        ],
      ),
    );
  }

  Widget buildFormContainer() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              Text(
                "New Password",
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              PasswordInput(
                controller: passwordController,
                hintText: '*************',
              ),
              SizedBox(height: 10),
              Text(
                "Confirm New Password",
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),

              PasswordInput(
                controller: passwordController,
                hintText: '*************',
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Container(
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),

                    color: Color(0xffE3E3E3),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Confirmation failed. Please check the number",
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontSize: 8,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              buildButton80("Creat New Password", _creatnewPassword),
            ],
          ),
        ),
      ),
    );
  }

  void _creatnewPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _secureStorage.write(
          key: 'password',
          value: passwordController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please log in.'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ), //LoginScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }
}
