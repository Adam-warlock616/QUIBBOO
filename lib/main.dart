import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/admin.dart';
import 'package:t_store/adminloginscreen.dart';
import 'package:t_store/login.dart';
import 'package:t_store/signup.dart';
import 'package:t_store/welcome_screen.dart';

import 'forgot_password_screen.dart';
import 'otp_verification_screen.dart';
import 'new_password_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue.shade200,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.blue.shade200,
        ),
      ),
      themeMode: ThemeMode.system, // Auto light/dark mode
      initialRoute: '/', // Changed to '/' to match your WelcomeScreen
      routes: {
        // Main routes
        '/': (context) => const WelcomeScreen(), // Your initial screen
        '/login': (context) => const EmployeeLoginScreen(),
        '/signup': (context) => const EmployeeSignInScreen(),

        // Password recovery routes
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/otp-verification': (context) => const OTPVerificationScreen(),
        '/new-password': (context) => const NewPasswordScreen(),

        // Admin routes
        '/admin-login': (context) => const AdminLoginScreen(),
        // '/admin-dashboard': (context) => const AdminDashboard(
        //   employeeName: null,
        // ),

        // Employee routes
        '/employee-login': (context) => const EmployeeLoginScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle any undefined routes here
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Page not found!'),
            ),
          ),
        );
      },
    );
  }
}
