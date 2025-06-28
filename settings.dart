import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit_builder/main_page.dart';
import 'UserService.dart';
import 'UserHabitsService.dart';
import 'LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingsScreen extends StatefulWidget {
  final String userId; // Optional userId, can be null if not provided
  const SettingsScreen({super.key, required this.userId});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Assuming userId is passed to the SettingsScreen
  bool _notificationsEnabled = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showResetAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Account'),
        content: const Text('Are you sure you want to reset all your habit data? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(widget.userId))),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement reset logic
              ResetUser(widget.userId);
              resetHabits( widget.userId);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(widget.userId)));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account data reset successfully')),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to permanently delete your account? All data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(widget.userId))),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteUser(widget.userId);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Loginscreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChangeUsernameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Username'),
        content: TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            hintText: 'Enter new username',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(widget.userId))),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_usernameController.text.trim().isNotEmpty) {
                // Implement username change logic
                changeUsername(widget.userId, _usernameController.text.trim());
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(widget.userId)));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Username updated successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Enter new password',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(widget.userId))),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_passwordController.text.trim().isNotEmpty) {
                // Implement password change logic
                changePassword(widget.userId, _passwordController.text.trim());
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(widget.userId)));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(widget.userId))),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement logout logic
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Loginscreen()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(widget.userId)),
          ),
        ),
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFECC7CE),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notification Toggle
         

          // Account Settings Section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Account Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Reset Account Data'),
            onTap: _showResetAccountDialog,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Change Username'),
            onTap: _showChangeUsernameDialog,
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: _showChangePasswordDialog,
          ),
          const Divider(),

          // Danger Zone Section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Danger Zone',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: _showDeleteAccountDialog,
          ),
        ],
      ),
    );
  }
}