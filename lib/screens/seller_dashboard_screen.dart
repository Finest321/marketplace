import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'sign_in_screen.dart'; // Import your SignInScreen
// import 'settings_screen.dart'; // If you have a settings screen

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key, required String name});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = 'Electronics';
  File? _imageFile;
  bool _isLoading = false;
  String? _sellerName;

  @override
  void initState() {
    super.initState();
    _fetchSellerName();
  }

  Future<void> _fetchSellerName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final metaName = user.userMetadata?['name'];
    if (metaName != null) {
      setState(() => _sellerName = metaName);
      return;
    }

    final response = await Supabase.instance.client
        .from('users')
        .select('name')
        .eq('id', user.id)
        .maybeSingle();

    if (response != null && response['name'] != null) {
      setState(() => _sellerName = response['name']);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    final name = _sellerName ?? 'Seller';
    if (hour < 12) return 'Good morning, $name!';
    if (hour < 17) return 'Good afternoon, $name!';
    return 'Good evening, $name!';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _uploadProduct() async {
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      await Supabase.instance.client.storage
          .from('product_images')
          .upload(fileName, _imageFile!);

      final imageUrl = Supabase.instance.client.storage
          .from('product_images')
          .getPublicUrl(fileName);

      await Supabase.instance.client.from('products').insert({
        'title': _titleController.text.trim(),
        'price': int.parse(_priceController.text.trim()),
        'category': _category,
        'image_url': imageUrl,
        'seller_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Product uploaded successfully',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      _formKey.currentState!.reset();
      setState(() {
        _imageFile = null;
        _category = 'Electronics';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.orange.shade50,
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
        ],
      ),
    );

    if (shouldLogout == true) {
      await Supabase.instance.client.auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
            (route) => false,
      );
    }
  }

  void _openSettings() {
    // Navigate to your settings screen
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings tapped')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu), // 3 horizontal dots
            onSelected: (value) {
              if (value == 'logout') {
                _confirmLogout();
              } else if (value == 'settings') {
                _openSettings();
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/aura_logo.png', height: 100),
              const SizedBox(height: 20),

              Text(
                _getGreeting(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Product Title', Icons.title),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                decoration: _inputDecoration('Price (₦)', Icons.attach_money),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null ? 'Enter valid price' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _category,
                items: ['Electronics', 'Fashion', 'Home', 'Beauty']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _category = val ?? 'Electronics'),
                decoration: _inputDecoration('Category', Icons.category),
              ),
              const SizedBox(height: 16),

              _imageFile == null
                  ? ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Select Image'),
                onPressed: _pickImage,
              )
                  : Column(
                children: [
                  Image.file(_imageFile!, height: 150),
                  TextButton(
                    onPressed: () => setState(() => _imageFile = null),
                    child: const Text('Remove Image'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text('Upload Product'),
                onPressed: _uploadProduct,
              ),
            ],
          ),
        ),
      ),
    );
  }
}