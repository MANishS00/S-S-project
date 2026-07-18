import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/profile/presentation/viewmodels/profile_viewmodel.dart';

Drawer appDrawer(BuildContext context) {
  final authViewModel = Provider.of<AuthViewModel>(context);
  final profileViewModel = Provider.of<ProfileViewModel>(context);

  // Fetch profile if not already fetched
  if (authViewModel.isAuthenticated && profileViewModel.profile == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileViewModel.fetchProfile();
    });
  }

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        if (authViewModel.isAuthenticated)
          Consumer<ProfileViewModel>(
            builder: (context, profileVM, child) {
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xffDCD6F7),
                ),
                accountName: Text(authViewModel.userName ?? 'User Name'),
                accountEmail:
                    Text(authViewModel.userName ?? 'user@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: profileVM.profile?.image != null
                      ? NetworkImage(profileVM.profile!.image!)
                      : const AssetImage('assets/images/pic.png')
                          as ImageProvider,
                ),
              );
            },
          )
        else
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xffA6B1E1),
            ),
            child: Text(
              'Welcome \nGuest',
              style: TextStyle(color: Colors.white),
            ),
          ),
        _createDrawerItem(
          icon: Icons.home,
          text: 'Home',
          onTap: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        _createDrawerItem(
          icon: Icons.shopping_basket,
          text: 'Products',
          onTap: () => Navigator.pushNamed(context, '/product_list'),
        ),
        if (authViewModel.isAuthenticated) ...[
          _createDrawerItem(
            icon: Icons.person,
            text: 'Profile',
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          _createDrawerItem(
            icon: Icons.account_balance_wallet,
            text: 'Wallet',
            onTap: () => Navigator.pushNamed(context, '/wallet'),
          ),
          _createDrawerItem(
            icon: Icons.group,
            text: 'Referrals',
            onTap: () => Navigator.pushNamed(context, '/referrals'),
          ),
        ],
        _createDrawerItem(
          icon: Icons.info,
          text: 'About',
          onTap: () => Navigator.pushNamed(context, '/about'),
        ),
        _createDrawerItem(
          icon: Icons.help,
          text: 'Help',
          onTap: () => Navigator.pushNamed(context, '/help'),
        ),
        if (authViewModel.isAuthenticated)
          _createDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              authViewModel.logout();
              Navigator.pushReplacementNamed(context, '/home');
            },
          )
        else
          _createDrawerItem(
            icon: Icons.login,
            text: 'Login',
            onTap: () => Navigator.pushNamed(context, '/login'),
          ),
        if (!authViewModel.isAuthenticated)
          _createDrawerItem(
            icon: Icons.person_add,
            text: 'Register',
            onTap: () => Navigator.pushNamed(context, '/register'),
          ),
      ],
    ),
  );
}

Widget _createDrawerItem({
  required IconData icon,
  required String text,
  required GestureTapCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: onTap,
  );
}
