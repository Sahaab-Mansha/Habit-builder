import 'package:flutter/material.dart';
import 'package:habit_builder/Taskpage.dart';
import 'package:habit_builder/welcome_screen.dart';
import 'UserService.dart'; // Import your Isar database functions
import 'main_page.dart'; // Import the main page you want to navigate to
import 'SignupScreen.dart';
import 'user_model.dart';
import 'streak.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle login
  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showAlert("Both fields are required!");
      return;
    }

    // Check if user exists
    User? user = await isUserAvailable(username);

    if (user == null) {
      // If user is not available, show an alert
      _showAlert("User not available. Please sign up.");
    } else {
      // If user exists, check password
      bool isPasswordCorrect = await checkPassword(username, password);

      if (!isPasswordCorrect) {
        // If password is incorrect, show an alert
        _showAlert("Incorrect password.");
      } else {
        // If both are correct, navigate to the main page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>HomeScreen(user.userId)),
        );
      }
    }
  }

  // Function to show alert dialogs
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double logoWidth = screenWidth * 0.7; // 50% of screen width
    double logoHeight = logoWidth * 0.5; // Maintain aspect ratio
    double textBoxWidth = screenWidth * 0.8; // 80% of screen width
    double textBoxHeight = screenHeight * 0.4; // 10% of screen height
    double buttonHeight = textBoxHeight * 0.13; // 10% of text box height
    double buttonWidth = textBoxWidth * 0.8; // Same width as text box

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 225, 245, 218),
      body: SingleChildScrollView(
  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), // handles keyboard
  child: Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.05),
        SizedBox(
          width: logoWidth,
          height: logoHeight,
          child: Image.asset('assets/logo.png'),
        ),
        SizedBox(height: screenHeight * 0.05),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 176, 208, 231),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromRGBO(176, 208, 231, 1),
            ),
          ),
          width: textBoxWidth,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Username", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              Text("Password", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  prefixIcon: Icon(Icons.password),
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 199, 206),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Login", style: TextStyle(fontSize: 20,color: Colors.black)),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signupscreen()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    ),
  ),
),

    );
  }
}
