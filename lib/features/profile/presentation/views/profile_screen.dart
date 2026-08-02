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

    if (authViewModel.isAuthenticated && profileViewModel.profile == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profileViewModel.fetchProfile();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body: authViewModel.isAuthenticated
          ? Consumer<ProfileViewModel>(
              builder: (context, profileVM, child) {
                if (profileVM.profile == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final profile = profileVM.profile!;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildProfileHeader(
                        context,
                        authViewModel,
                        profile,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          28,
                          28,
                          28,
                          30,
                        ),
                        child: Column(
                          children: [
                            // Shipping Addresses
                            _ProfileMenuItem(
                              icon: Icons.location_on_outlined,
                              title: 'Shipping Addresses',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/shipping_address_form',
                                );
                              },
                            ),

                            const SizedBox(height: 18),

                            // Payment Methods
                            _ProfileMenuItem(
                              icon: Icons.credit_card_outlined,
                              title: 'Bank Details',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/bank_details',
                                );
                              },
                            ),

                            const SizedBox(height: 18),

                            _ProfileMenuItem(
                              icon: Icons.offline_share_outlined,
                              title: 'My Refrals',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/referrals',
                                );
                              },
                            ),

                            const SizedBox(height: 18),

                            // Orders
                            _ProfileMenuItem(
                              icon: Icons.receipt_long_outlined,
                              title: 'Orders',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/order_history',
                                );
                              },
                            ),

                            const SizedBox(height: 18),

                            // Favorite
                            _ProfileMenuItem(
                              icon: Icons.favorite_border,
                              title: 'Consultant',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/contact',
                                );
                              },
                            ),

                            const SizedBox(height: 18),

                            // Settings
                            _ProfileMenuItem(
                              icon: Icons.settings_outlined,
                              title: 'Settings',
                              onTap: () {
                                // TODO: Navigate to Settings
                                // Navigator.pushNamed(
                                //   context,
                                //   '/settings',
                                // );
                              },
                            ),

                            const SizedBox(height: 18),

                            // Logout
                            _ProfileMenuItem(
                              icon: Icons.logout_outlined,
                              title: 'Log Out',
                              onTap: () {
                                _showLogoutDialog(
                                  context,
                                  authViewModel,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : _buildLoggedOutView(context),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    AuthViewModel authViewModel,
    dynamic profile,
  ) {
    return SizedBox(
      height: 220,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Purple Header
          ClipPath(
            clipper: ProfileHeaderClipper(),
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFd7eaff),
                    Color(0xFFE3F2FD),
                  ],
                ),
              ),
            ),
          ),

          // Profile Content
          Positioned(
            left: 28,
            right: 28,
            top: 70,
            child: Row(
              children: [
                // Profile Image
                Container(
                  width: 82,
                  height: 82,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 39,
                    backgroundImage: profile.image != null
                        ? NetworkImage(profile.image!)
                        : const AssetImage('assets/images/pic.png')
                            as ImageProvider,
                  ),
                ),

                const SizedBox(width: 18),

                // Name + Phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authViewModel.userName ?? 'Name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.phone ??
                            authViewModel.userEmail ??
                            'Phone number',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        authViewModel.userEmail ?? 'Email',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 28,
            bottom: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/profile_form',
                );
              },
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xff5D3970),
                  size: 27,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 80,
              color: Color(0xff5D3970),
            ),
            const SizedBox(height: 20),
            const Text(
              'You are not logged in',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/login',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5D3970),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/register',
                );
              },
              child: const Text(
                'Create an account',
                style: TextStyle(
                  color: Color(0xff5D3970),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    AuthViewModel authViewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                authViewModel.logout();

                Navigator.pop(context);

                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff5D3970),
                foregroundColor: Colors.white,
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xff5D3970),
                size: 27,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff292435),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);

    path.lineTo(size.width * 0.58, size.height);

    path.cubicTo(
      size.width * 0.78,
      size.height - 5,
      size.width * 0.95,
      size.height - 45,
      size.width,
      size.height - 100,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
    CustomClipper<Path> oldClipper,
  ) {
    return false;
  }
}
