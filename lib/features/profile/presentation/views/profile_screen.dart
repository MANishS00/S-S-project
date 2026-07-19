import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    // Fetch profile if not already fetched
    if (authViewModel.isAuthenticated && profileViewModel.profile == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profileViewModel.fetchProfile();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xffF4EEFF),
      body: authViewModel.isAuthenticated
          ? Consumer<ProfileViewModel>(
              builder: (context, profileVM, child) {
                if (profileVM.profile == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final profile = profileVM.profile!;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profile.image != null
                            ? NetworkImage(profile.image!)
                            : const AssetImage('assets/images/pic.png')
                                as ImageProvider,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        authViewModel.userName ?? 'Name',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email: ${authViewModel.userEmail ?? 'user@example.com'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Phone: ${profile.phone ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Address: ${profile.address1 ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile_form');
                        },
                        child: const Text('Edit Profile Info'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/shipping_address_form');
                        },
                        child: const Text('Edit Shipping Address'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/wallet');
                        },
                        child: const Text('My Wallet'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/referrals');
                        },
                        child: const Text('My Referrals'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/order_history');
                        },
                        child: const Text('Order History'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/bank_details');
                        },
                        child: const Text('Bank Details'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/contact');
                        },
                        child: const Text('Consultant'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          authViewModel.logout();
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are not logged in.'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
    );
  }
}
