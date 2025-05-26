import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../service/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const ProfileScreen({Key? key, this.onBackToHome}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  UserModel? _userData;
  bool _isLoading = true;
  bool _isSaved = true;

  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _usernameController.addListener(() {
      setState(() {
        _isSaved = false;
      });
    });

    _phoneController.addListener(() {
      setState(() {
        _isSaved = false;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isSaved = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.getCurrentUser();
      setState(() {
        _userData = userData;
        _isLoading = false;
        if (userData != null) {
          _usernameController.text = userData.username ?? '';
          _phoneController.text = userData.phone ?? '';
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error loading profile: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (_userData != null) {
          final updatedUser = UserModel(
            uid: _userData!.uid,
            email: _userData!.email,
            username: _usernameController.text.trim(),
            phone: _phoneController.text.trim(),
          );

          await _userService.updateUserProfile(updatedUser);
          setState(() {
            _userData = updatedUser;
            _isSaved = true;
          });
          _showSnackBar('Profile updated successfully');
        }
      } catch (e) {
        _showSnackBar('Error updating profile: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A72B0)),
          onPressed: () {
            if (widget.onBackToHome != null) {
              widget.onBackToHome!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF4A72B0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF4A72B0)),
            onPressed: () async {
              await _userService.logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _userData == null
                ? const Center(child: Text('No user data available'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: _image != null ? FileImage(_image!) : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(Icons.add, color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                label: 'Name',
                                controller: _usernameController,
                              ),
                              _buildTextField(
                                label: 'Phone Number',
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                              _buildTextField(
                                label: 'Email',
                                value: _userData!.email,
                                enabled: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A72B0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? value,
    TextEditingController? controller,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? value : null,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (val) {
          if (enabled && (val == null || val.isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
