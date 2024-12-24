import 'package:flutter/material.dart';
import '../api_service.dart';
import '../user_model.dart';
import 'register_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = await ApiService.getUserData(widget.userId);
      if (user != null) {
        setState(() {
          nameController.text = user.name;
          phoneController.text = user.phone.toString();
          emailController.text = user.email;
          isLoading = false;
        });
      } else {
        _showErrorSnackbar('Failed to load user data. User may not exist.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Error loading user data');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    bool success = await ApiService.updateUserProfile(
      widget.userId,
      nameController.text,
      phoneController.text,
      emailController.text,
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } else {
      _showErrorSnackbar('Failed to update profile');
    }
  }

  Future<void> _deleteAccount() async {
    bool success = await ApiService.deleteUser(widget.userId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully!')),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    } else {
      _showErrorSnackbar('Failed to delete account');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateUserProfile,
                    child: const Text('Update Profile'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _deleteAccount,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
            ),
    );
  }
}
