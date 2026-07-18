// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/auth/presentation/views/login_screen.dart';
import 'features/auth/presentation/views/register_screen.dart';
import 'features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'features/profile/presentation/viewmodels/shipping_address_viewmodel.dart';
import 'features/profile/presentation/views/profile_info_form_screen.dart';
import 'features/profile/presentation/views/profile_screen.dart';
import 'features/profile/presentation/views/shipping_address_form_screen.dart';
import 'features/product/presentation/viewmodels/product_viewmodel.dart';
import 'features/category/presentation/viewmodels/category_viewmodel.dart';
import 'features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'features/checkout/presentation/viewmodels/checkout_viewmodel.dart';
import 'features/checkout/presentation/views/order_success_screen.dart';
import 'features/home/presentation/views/home_page.dart';
import 'features/static_pages/presentation/views/about_screen.dart';
import 'features/static_pages/presentation/views/contact_screen.dart';
import 'features/static_pages/presentation/views/help_screen.dart';
import 'features/wallet/presentation/viewmodels/wallet_viewmodel.dart';
import 'features/consultant/presentation/viewmodels/consultant_viewmodel.dart';
import 'features/wallet/presentation/views/wallet_screen.dart';
import 'features/profile/presentation/views/referrals_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()..checkAuthStatus()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => ShippingAddressViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => CheckoutViewModel()),
        ChangeNotifierProvider(create: (_) => WalletViewModel()),
        ChangeNotifierProvider(create: (_) => ConsultantViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sales & Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile_form': (context) => ProfileFormScreen(),
        '/shipping_address_form': (context) => ShippingAddressForm(),
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => HomePage(),
        '/about': (context) => AboutPage(),
        '/help': (context) => HelpPage(),
        '/contact': (context) => ContactUsPage(),
        '/order_sucess': (context) => OrderSuccessScreen(),
        '/wallet': (context) => WalletScreen(),
        '/referrals': (context) => ReferralsScreen(),
      },
    );
  }
}
