import 'dart:io';
import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  _ProfileFormScreenState createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipcodeController;
  late TextEditingController _countryController;
  File? _imageFile;
  String? _initialImageUrl;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfileData();
  }

  void _initializeControllers() {
    _phoneController = TextEditingController();
    _address1Controller = TextEditingController();
    _address2Controller = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipcodeController = TextEditingController();
    _countryController = TextEditingController();
  }

  Future<void> _loadProfileData() async {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    try {
      await profileViewModel.fetchProfile();
      final profile = profileViewModel.profile;

      if (profile != null) {
        _phoneController.text = profile.phone ?? '';
        _address1Controller.text = profile.address1 ?? '';
        _address2Controller.text = profile.address2 ?? '';
        _cityController.text = profile.city ?? '';
        _stateController.text = profile.state ?? '';
        _zipcodeController.text = profile.zipcode ?? '';
        _countryController.text = profile.country ?? '';
        _initialImageUrl = profile.image;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: ${error.toString()}')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<ProfileViewModel>(context, listen: false)
            .updateProfile(
          image: _imageFile,
          phone: _phoneController.text,
          address1: _address1Controller.text,
          address2: _address2Controller.text,
          city: _cityController.text,
          state: _stateController.text,
          zipcode: _zipcodeController.text,
          country: _countryController.text,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update profile: ${error.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipcodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                const Text("Complete Your Profile", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        )
                      : _initialImageUrl != null
                          ? Image.network(
                              _initialImageUrl!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 150),
                ),
                _buildTextField(_phoneController, 'Phone', TextInputType.phone),
                _buildTextField(_address1Controller, 'Address 1'),
                _buildTextField(_address2Controller, 'Address 2'),
                _buildTextField(_cityController, 'City'),
                _buildTextField(_stateController, 'State'),
                _buildTextField(
                    _zipcodeController, 'Zip Code', TextInputType.number),
                _buildTextField(_countryController, 'Country'),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff024874),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitProfile,
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text("Skip")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      [TextInputType? keyboardType]) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }
}
