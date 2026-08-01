import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../consultant/presentation/viewmodels/consultant_viewmodel.dart';
import '../../../profile/presentation/viewmodels/profile_viewmodel.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _productServiceController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      final authVM = Provider.of<AuthViewModel>(context, listen: false);

      await profileVM.fetchProfile();

      if (profileVM.profile != null) {
        if ((profileVM.profile!.phone ?? '').isNotEmpty) {
          _mobileController.text = profileVM.profile!.phone!;
        }
      }

      if (authVM.user != null) {
        final fullName = '${authVM.user!.firstName} ${authVM.user!.lastName}'.trim();
        if (fullName.isNotEmpty) {
          _nameController.text = fullName;
        }
        if (authVM.user!.email.isNotEmpty) {
          _emailController.text = authVM.user!.email;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _productServiceController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final consultantVM = Provider.of<ConsultantViewModel>(context, listen: false);
      final messenger = ScaffoldMessenger.of(context);

      try {
        await consultantVM.submitConsultantRequest(
          name: _nameController.text.trim(),
          productService: _productServiceController.text.trim(),
          mobileNumber: _mobileController.text.trim(),
          email: _emailController.text.trim(),
          message: _messageController.text.trim(),
        );

        messenger.showSnackBar(
          const SnackBar(content: Text('Request submitted successfully!')),
        );
        _productServiceController.clear();
        _messageController.clear();
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to submit request: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final consultantVM = Provider.of<ConsultantViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Contact Us & Consultant Request'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Center(
                child: Icon(
                  Icons.support_agent,
                  size: 80,
                  color: Color(0xff424874),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Consultant Request / Contact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Person Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _productServiceController,
                      decoration: const InputDecoration(
                        labelText: 'Product / Service Required',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product or service';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message / Details',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter details';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    consultantVM.isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff424874),
                              ),
                              onPressed: _submitForm,
                              child: const Text(
                                'Submit Request',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.blue,
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.xTwitter,
                        color: Colors.blue,
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Colors.blue,
                        size: 28,
                      ),
                      onPressed: () {},
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
