import 'package:final_app/firebase_options.dart';
import 'package:final_app/pages/customer/customer_delivery_page.dart';
import 'package:final_app/pages/customer/customer_pickup_page.dart';
import 'package:final_app/services/auth/auth_page.dart';
import 'package:final_app/pages/customer/customer_home_nav.dart';
import 'package:final_app/pages/customer/customer_settings_page.dart';
import 'package:final_app/pages/register_page.dart';
import 'package:final_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_app/pages/intro_page.dart';
import 'package:final_app/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  // Initialize widgets and firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Notify about changes in themes
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness? _previousBrightness;

  // Theme tracker
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check system brightness
    final brightness = MediaQuery.of(context).platformBrightness;

    // Update theme only if brightness has changed
    if (_previousBrightness != brightness) {
      // Schedule the theme update after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ThemeProvider>(context, listen: false).updateTheme(brightness);
      });
      // Update the previous brightness
      _previousBrightness = brightness;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/intro_page': (context) => const IntroPage(),
        '/register_page': (context) => const RegisterPage(onTap: null),
        '/auth_page': (context) => const AuthPage(),
        '/login_page': (context) => const LoginPage(onTap: null),
        '/customer_settings_page': (context) => const CustomerSettingsPage(),
        '/customer_home_nav': (context) => const CustomerHomeNav(),
        '/customer_pickup_page': (context) {
          final requestId = ModalRoute.of(context)!.settings.arguments as String;
          return CustomerPickupPage(requestId: requestId);
        },
        '/customer_delivery_page': (context) {
          final requestId = ModalRoute.of(context)!.settings.arguments as String;
          return CustomerDeliveryPage(requestId: requestId);
        },
      },
    );
  }
}
