import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  _ProfileFormScreenState createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  static const Color _brand = Color(0xff024874);
  static const double _radius = 14.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: profileVM.isLoading
            ? const Center(child: CircularProgressIndicator(color: _brand))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Skip, top-right
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/home'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                          child: const Text('Skip'),
                        ),
                      ),

                      const SizedBox(height: 8),
                      const Text(
                        'Complete Your Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1a1a1a),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'A few details to help us personalize your account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 28),
                      Center(child: _buildAvatarPicker(profileVM)),

                      const SizedBox(height: 32),
                      _sectionLabel('Contact'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: profileVM.phoneController,
                        labelText: 'Phone',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 20),
                      _sectionLabel('Address'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: profileVM.address1Controller,
                        labelText: 'Address 1',
                        icon: Icons.home_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: profileVM.address2Controller,
                        labelText: 'Address 2',
                        icon: Icons.apartment_outlined,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: profileVM.cityController,
                              labelText: 'City',
                              icon: Icons.location_city_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: profileVM.stateController,
                              labelText: 'State',
                              icon: Icons.map_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: profileVM.zipcodeController,
                              labelText: 'Zip Code',
                              icon: Icons.pin_drop_outlined,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: profileVM.countryController,
                              labelText: 'Country',
                              icon: Icons.flag_outlined,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _brand,
                            disabledBackgroundColor: _brand.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_radius),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _isSubmitting ? null : () => _handleSubmit(profileVM),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _handleSubmit(ProfileViewModel profileVM) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      await profileVM.submitProfile();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${error.toString()}'),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Colors.grey[500],
      ),
    );
  }

  Widget _buildAvatarPicker(ProfileViewModel profileVM) {
    final hasLocalImage = profileVM.selectedImage != null;
    final hasNetworkImage = profileVM.profile?.image != null;

    return GestureDetector(
      onTap: profileVM.pickImage,
      child: Stack(
        children: [
          Container(
            height: 128,
            width: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasLocalImage
                ? Image.file(
                    profileVM.selectedImage!,
                    fit: BoxFit.cover,
                  )
                : hasNetworkImage
                    ? Image.network(
                        profileVM.profile!.image!,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.person_outline, size: 56, color: Colors.grey[400]),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _brand,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xffF7F8FA),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: _brand, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: Colors.red[400]!, width: 1),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}