import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io'; // For network check

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String _role = 'Buyer'; // Default role
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // Check network connectivity
      final result = await InternetAddress.lookup('example.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw const SocketException('No Internet');
      }

      // Create user in Supabase Auth
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;

      if (user != null) {
        debugPrint('Selected role: $_role'); // Debug check

        // Insert extra profile info into "users" table
        await Supabase.instance.client.from('users').insert({
          'id': user.id,
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'role': _role, // <-- Correctly saves Buyer or Seller
          'created_at': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Account created successfully',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to SignIn after signup
        Navigator.pushReplacementNamed(context, '/signin');
      }
    } on AuthException catch (e) {
      final isDuplicate = e.message.contains('already registered');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isDuplicate
                ? 'Account already exists'
                : 'Sign-up failed: ${e.message}',
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No internet connection',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-up failed: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool isPassword = false,
        VoidCallback? toggleVisibility,
        bool obscure = true}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: toggleVisibility,
      )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/aura_logo.png', height: 100),
              const SizedBox(height: 20),
              const Text(
                'Welcome!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Role dropdown
              DropdownButtonFormField<String>(
                value: _role,
                items: ['Buyer', 'Seller']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) {
                  setState(() => _role = val ?? 'Buyer');
                  debugPrint('Role selected: $_role'); // Debug
                },
                decoration: _inputDecoration('Role', Icons.person_outline),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Name', Icons.person),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration('Phone Number', Icons.phone),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (v.trim().length > 11) {
                    return 'Phone must not exceed 11 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email', Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                v == null || !v.contains('@') ? 'Enter valid email' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: _inputDecoration(
                  'Password',
                  Icons.lock,
                  isPassword: true,
                  toggleVisibility: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  obscure: _obscurePassword,
                ),
                obscureText: _obscurePassword,
                validator: (v) =>
                v == null || v.length < 6 ? 'Minimum 6 characters' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmController,
                decoration: _inputDecoration(
                  'Confirm Password',
                  Icons.lock_outline,
                  isPassword: true,
                  toggleVisibility: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  obscure: _obscureConfirm,
                ),
                obscureText: _obscureConfirm,
                validator: (v) =>
                v != _passwordController.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 24),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Sign Up'),
                onPressed: _signUp,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/signin'),
                child: const Text('Already have an account? Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}