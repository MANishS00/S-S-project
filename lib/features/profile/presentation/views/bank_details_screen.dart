import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../../data/models/bank_details_model.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contactTypeController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      await profileVM.fetchBankDetails();
      _populateForm(profileVM.bankDetails);
    });
  }

  void _populateForm(BankDetailsModel? details) {
    if (details != null) {
      _nameController.text = details.accountHolderName;
      _emailController.text = details.email;
      _phoneController.text = details.phoneNumber;
      _contactTypeController.text = details.contactType;
      _accountNumberController.text = details.accountNumber;
      _ifscController.text = details.ifscCode;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _contactTypeController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  Future<void> _saveBankDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final details = BankDetailsModel(
        id: 0,
        accountHolderName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        contactType: _contactTypeController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        ifscCode: _ifscController.text.trim(),
      );

      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      final messenger = ScaffoldMessenger.of(context);

      try {
        await profileVM.submitBankDetails(details);
        setState(() {
          _isEditing = false;
        });
        messenger.showSnackBar(
          const SnackBar(content: Text('Bank details updated successfully')),
        );
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to update bank details: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);
    final details = profileVM.bankDetails;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Bank Details'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _populateForm(profileVM.bankDetails);
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (details != null && !_isEditing)
              Card(
                elevation: 4,
                color: const Color(0xffDCD6F7),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saved Bank Account',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Account Holder'),
                        subtitle: Text(details.accountHolderName),
                      ),
                      ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: const Text('Account Number'),
                        subtitle: Text(details.accountNumber),
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_balance),
                        title: const Text('IFSC Code'),
                        subtitle: Text(details.ifscCode),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(details.email),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Phone Number'),
                        subtitle: Text(details.phoneNumber),
                      ),
                    ],
                  ),
                ),
              ),

            Form(
              key: _formKey,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing || details == null
                            ? 'Enter Bank Account Information'
                            : 'Update Information',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Account Holder Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Field required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _accountNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Account Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Field required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _ifscController,
                        decoration: const InputDecoration(
                          labelText: 'IFSC Code',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Field required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Field required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Field required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _contactTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Contact Type (e.g. Personal/Business)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff424874),
                          ),
                          onPressed: _isLoading ? null : _saveBankDetails,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Save Bank Details',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
