import 'package:app/core/theme/app_colors.dart';
import 'package:app/features/home/presentation/views/AnimatedBottomNav.dart';
import 'package:app/features/wallet/presentation/views/wallet_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/drawer.dart';
import '../../../profile/presentation/views/profile_screen.dart';
import 'home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const WalletScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: appDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: AnimatedBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
        extendBody: true,

    );
  }
}
