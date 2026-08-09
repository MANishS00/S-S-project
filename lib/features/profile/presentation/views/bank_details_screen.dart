import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchBankDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);
    final details = profileVM.bankDetails;
    final isEditing = profileVM.isEditingBankDetails;
    final isLoading = profileVM.isBankDetailsLoading;

    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title:
              const Text('Bank Details', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Card(
                  // elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing || details == null
                              ? 'Enter Bank Account Information'
                              : 'Update Information',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: profileVM.bankNameController,
                          decoration: const InputDecoration(
                            labelText: 'Account Holder Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Field required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: profileVM.bankAccountNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Account Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Field required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: profileVM.bankIfscController,
                          decoration: const InputDecoration(
                            labelText: 'IFSC Code',
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.characters,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Field required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: profileVM.bankEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Field required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: profileVM.bankPhoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Field required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: profileVM.bankContactTypeController,
                          decoration: const InputDecoration(
                            labelText: 'Contact Type (e.g. Personal/Business)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final messenger = ScaffoldMessenger.of(context);
                        try {
                          await profileVM.saveBankDetails();
                          messenger.showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Bank details updated successfully')),
                          );
                        } catch (e) {
                          messenger.showSnackBar(
                            SnackBar(
                                content:
                                    Text('Failed to update bank details: $e')),
                          );
                        }
                      }
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
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
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            )));
  }
}
