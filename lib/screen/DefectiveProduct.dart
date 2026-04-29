import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DefectiveProductScreen extends StatefulWidget {
  const DefectiveProductScreen({super.key});

  @override
  State<DefectiveProductScreen> createState() => _DefectiveProductScreenState();
}

class _DefectiveProductScreenState extends State<DefectiveProductScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _orderNumberCtrl = TextEditingController();
  final TextEditingController _addressCtrl     = TextEditingController();
  final TextEditingController _phoneCtrl       = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  DateTime? _orderDate;
  File? _selectedImage;
  bool _isSubmitting = false;

  // ── Pick image from gallery ──────────────────────────────────────────────
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  // ── Pick date ────────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.blue),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _orderDate = picked);
  }

  // ── Submit report ────────────────────────────────────────────────────────
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_orderDate == null) {
      _showSnack("Please select the order date", Colors.blue);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String? imageUrl;

      // 1. Upload image to Supabase Storage (if selected)
      if (_selectedImage != null) {
        final userId  = _supabase.auth.currentUser?.id ?? 'anon';
        final fileName =
            'defective/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await _supabase.storage
            .from('defective-products')     // ← create this bucket in Supabase
            .upload(fileName, _selectedImage!);

        imageUrl = _supabase.storage
            .from('defective-products')
            .getPublicUrl(fileName);
      }

      // 2. Insert record into defective_queries table
      await _supabase.from('defective_queries').insert({
        'user_id':      _supabase.auth.currentUser?.id,
        'order_number': _orderNumberCtrl.text.trim(),
        'order_date':   _orderDate!.toIso8601String(),
        'address':      _addressCtrl.text.trim(),
        'phone':        _phoneCtrl.text.trim(),
        'description':  _descriptionCtrl.text.trim(),
        'image_url':    imageUrl,
        'status':       'pending',
        'created_at':   DateTime.now().toIso8601String(),
      });

      if (mounted) {
        _showSnack("Report submitted successfully!", Colors.green);
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Submit error: $e");
      if (mounted) _showSnack("Failed to submit: $e", Colors.blue);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  // ── UI ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Report Defective Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image Picker ─────────────────────────────────────────
              const _SectionLabel(label: "Product Image"),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined,
                          size: 48, color: Colors.blue),
                      const SizedBox(height: 8),
                      Text(
                        "Tap to upload defective product image",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_selectedImage != null) ...[
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: () => setState(() => _selectedImage = null),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 16),
                  label: const Text("Remove image",
                      style: TextStyle(color: Colors.red, fontSize: 13)),
                ),
              ],

              const SizedBox(height: 20),

              // ── Order Number ─────────────────────────────────────────
              const _SectionLabel(label: "Order Number *"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _orderNumberCtrl,
                hint: "e.g. ORD-20240512-001",
                icon: Icons.receipt_long,
                validator: (v) =>
                v == null || v.trim().isEmpty ? "Order number required" : null,
              ),

              const SizedBox(height: 16),

              // ── Date of Order ────────────────────────────────────────
              const _SectionLabel(label: "Date of Order *"),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Colors.blue, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _orderDate != null
                            ? "${_orderDate!.day.toString().padLeft(2, '0')}/"
                            "${_orderDate!.month.toString().padLeft(2, '0')}/"
                            "${_orderDate!.year}"
                            : "Select order date",
                        style: TextStyle(
                          color: _orderDate != null
                              ? Colors.black87
                              : Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Address ──────────────────────────────────────────────
              const _SectionLabel(label: "Delivery Address *"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _addressCtrl,
                hint: "Full delivery address",
                icon: Icons.location_on_outlined,
                maxLines: 3,
                validator: (v) =>
                v == null || v.trim().isEmpty ? "Address required" : null,
              ),

              const SizedBox(height: 16),

              // ── Phone ────────────────────────────────────────────────
              const _SectionLabel(label: "Contact Phone *"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneCtrl,
                hint: "Your phone number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Phone required";
                  if (v.trim().length < 10) return "Enter valid phone number";
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Description ──────────────────────────────────────────
              const _SectionLabel(label: "Issue Description"),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _descriptionCtrl,
                hint: "Describe the defect or issue with the product...",
                icon: Icons.description_outlined,
                maxLines: 4,
              ),

              const SizedBox(height: 32),

              // ── Submit Button ────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text(
                    "Submit Report",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.blue, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: Colors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _orderNumberCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }
}

// ── Section Label widget ─────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }
}