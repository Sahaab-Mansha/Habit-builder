import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

    @override
    _WelcomeScreenState createState() => _WelcomeScreenState();
  }

  class _WelcomeScreenState extends State<WelcomeScreen> {
    bool _isLoading = false;

    void _navigateToHome(BuildContext context) async {
      setState(() {
        _isLoading = true;
      });

    await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _isLoading = false;
      });

    
    }

    void _goToSettings() {
        
      Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>HomeScreen(widget.userId)),
          );
    }

    void _goToStreak() {
        
     Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>Streak(widget.userId)),
          );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFE1F5DA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'assests/logo.png',
                height: 40,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.local_fire_department_rounded, color: Colors.orange),
              onPressed: _goToStreak,
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black87),
              onPressed: () {
              
              },
            ),

            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black87),
              onPressed: _goToSettings,
            ),
            const SizedBox(width: 8),
          ],
        ),


        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome 👋',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6E9F4B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Habits are small steps that begin the journey to big changes. Start today and build a better you!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6E9F4B),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCEE9BE),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _isLoading ? null : () => _navigateToHome(context),
                    child: const Text(
                      'Okay 🌿',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6E9F4B)),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }