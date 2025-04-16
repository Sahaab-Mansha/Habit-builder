import 'package:flutter/material.dart';
import 'SignupScreen.dart';
class Loginscreen extends StatelessWidget {
  
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: logoWidth, // Set the width
                  height: logoHeight, // Set the height
                  child: Image.asset('assets/logo.png'),
                ),
                // Add your logo here
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 176, 208, 231),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromRGBO(176, 208, 231, 1),
                  ),
                ),
                width: textBoxWidth,
                height: textBoxHeight,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 236, 199, 206),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: textBoxHeight * 0.04,
                      
                    ),
                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          prefixIcon: Icon(
                            Icons.password,
                            color: Color.fromARGB(255, 236, 199, 206),
                          ),
                        ),
                      ),
                    ),
                    
                    Container(
                      width: buttonWidth ,  
                      height: buttonHeight,
                      margin: EdgeInsets.only(top: 25,left: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle login action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 236, 199, 206),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: textBoxHeight * 0.04,
                      
                    ),
                    GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Signupscreen()), // replace with your page
    );
  },
  child: Text(
    "Don't have an account? Sign up",
    style: TextStyle(
      fontSize: 15,
      color: const Color.fromARGB(255, 0, 0, 0),
      fontStyle: FontStyle.normal,
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
}
