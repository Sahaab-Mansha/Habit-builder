// screens/settings.dart
import 'package:flutter/material.dart';
import 'main_page.dart';  // adjust the import path to where your HomeScreen lives

class SettingsPage extends StatelessWidget {
  String userid;
  SettingsPage(this.userid,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // ── Bright yellow Anime-icon button ───────────────────
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (_) => HomeScreen('')),
                 );
                //
                // Otherwise, a simple pop will reveal HomeScreen underneath:
              
              },
              icon: const Text(
                '😊',               // anime-style emoji as the “icon”
                style: TextStyle(fontSize: 24),
              ),
              label: const Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade600,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
