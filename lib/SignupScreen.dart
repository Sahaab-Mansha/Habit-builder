import 'package:flutter/material.dart';
import 'user_model.dart'; // Import your user model and functions
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'LoginScreen.dart';
import 'UserService.dart';
import 'UserHabitsService.dart' ;

class Signupscreen extends StatefulWidget {
  @override
  _SignupscreenState createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  String selectedGender = 'Male';
  DateTime? selectedDate;
  final TextEditingController dobController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
        dobController.text = "${date.day}/${date.month}/${date.year}";
      });
    }
  }

  Future<void> _handleSignup() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Check if all fields are filled
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty || selectedDate == null) {
      _showAlert("Please fill all the fields.");
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      _showAlert("Passwords do not match.");
      return;
    }

    // Check if user already exists
    bool userExists = await isUserAvailable(username) != null;
    if (userExists) {
      _showAlert("User already exists.");
      return;
    }

    // Add the user to the database
    bool userAdded = await addUser(
      username: username,
      password: password,
      gender: selectedGender,
      dob: selectedDate!,
    );

    if (userAdded) {
      _showAlert("User successfully created!");
      // Optionally navigate to the login screen)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    } else {
      _showAlert("Error creating user.");
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Alert"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double logoWidth = screenWidth * 0.7;
    double logoHeight = logoWidth * 0.5;
    double textBoxWidth = screenWidth * 0.8;
    double textBoxHeight = screenHeight * 0.6;
    double buttonHeight = textBoxHeight * 0.08;
    double buttonWidth = textBoxWidth * 0.8;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 245, 218),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: logoWidth,
                  height: logoHeight,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 176, 208, 231),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: textBoxWidth,
                height: textBoxHeight,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Username"),
                    _inputField(Icons.person, "Enter your username", controller: usernameController),
                    _spacer(textBoxHeight),

                    _label("Password"),
                    _inputField(Icons.lock, "Enter your password", obscure: true, controller: passwordController),
                    _spacer(textBoxHeight),

                    _label("Confirm Password"),
                    _inputField(Icons.lock_outline, "Confirm your password", obscure: true, controller: confirmPasswordController),
                    _spacer(textBoxHeight),

                    _label("Date of Birth"),
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: _inputField(Icons.calendar_today, "Select your date of birth", controller: dobController),
                      ),
                    ),
                    _spacer(textBoxHeight),

                    _label("Gender"),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: InputDecoration(border: InputBorder.none),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: ['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 20),

                    Container(
                      width: buttonWidth,
                      height: buttonHeight,
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 236, 199, 206),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: textBoxHeight * 0.04),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(fontSize: 15, color: Colors.black),
      );

  Widget _inputField(IconData icon, String hintText, {bool obscure = false, TextEditingController? controller}) {
    return Container(
      margin: EdgeInsets.only(top: 3),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 236, 199, 206)),
        ),
      ),
    );
  }

  Widget _spacer(double boxHeight) => SizedBox(height: boxHeight * 0.01);
}
