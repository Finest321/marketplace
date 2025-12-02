import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/sign_up_screen.dart';
import 'screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bcbzqfqaqbtpeuxpkngi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJjYnpxZnFhcWJ0cGV1eHBrbmdpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzNTM5MjMsImV4cCI6MjA3OTkyOTkyM30.Ej39PRoa01zTF16gHMKyAeK3DxZKQL5stDaAyhdjrWs',
  );

  runApp(const AuraMarketplaceApp());
}

class AuraMarketplaceApp extends StatelessWidget {
  const AuraMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura Marketplace',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const SignUpScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/signin': (context) => const SignInScreen(),
      },
    );
  }
}

