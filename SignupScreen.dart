import 'package:flutter/material.dart';
import 'user_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'LoginScreen.dart';
import 'UserService.dart';
import 'UserHabitsService.dart';

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

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty || selectedDate == null) {
      _showAlert("Please fill all the fields.");
      return;
    }

    if (password != confirmPassword) {
      _showAlert("Passwords do not match.");
      return;
    }

    bool userExists = await isUserAvailable(username) != null;
    if (userExists) {
      _showAlert("User already exists.");
      return;
    }

    bool userAdded = await addUser(
      username: username,
      password: password,
      gender: selectedGender,
      dob: selectedDate!,
    );

    if (userAdded) {
      _showAlert("User successfully created!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginscreen()));
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double logoWidth = screenWidth * 0.7;
    double textBoxWidth = screenWidth * 0.85;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 245, 218),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 30),
                SizedBox(
                  width: logoWidth,
                  child: Image.asset('assets/logo.png'),
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 176, 208, 231),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: textBoxWidth,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Username"),
                      _inputField(Icons.person, "Enter your username", controller: usernameController),
                      SizedBox(height: 10),

                      _label("Password"),
                      _inputField(Icons.lock, "Enter your password", obscure: true, controller: passwordController),
                      SizedBox(height: 10),

                      _label("Confirm Password"),
                      _inputField(Icons.lock_outline, "Confirm your password", obscure: true, controller: confirmPasswordController),
                      SizedBox(height: 10),

                      _label("Date of Birth"),
                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: _inputField(Icons.calendar_today, "Select your date of birth", controller: dobController),
                        ),
                      ),
                      SizedBox(height: 10),

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
                        width: double.infinity,
                        height: 50,
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
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginscreen()));
                          },
                          child: Text(
                            "Already have an account? Login",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30), // Extra padding to avoid overflow
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      );

  Widget _inputField(IconData icon, String hintText,
      {bool obscure = false, TextEditingController? controller}) {
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
}
