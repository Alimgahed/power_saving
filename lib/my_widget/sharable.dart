import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool allowOnlyDigits;
  final bool useValidator; // <-- NEW

  const CustomTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.allowOnlyDigits = false,
    this.icon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.useValidator = true, // <-- DEFAULT true
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: allowOnlyDigits ? TextInputType.number : keyboardType,
        inputFormatters: allowOnlyDigits
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d*$'), // digits and optional decimal
                ),
              ]
            : null,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: useValidator
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'هذا الحقل مطلوب';
                }
                return null;
              }
            : null,
      ),
    );
  }
}


void showCustomErrorDialog({
  required String errorMessage,
  IconData icon = Icons.error_outline, // You can change the icon if needed
}) {
  Get.defaultDialog(
    title: "خطأ",
    titleStyle: TextStyle(
      color: Colors.red, // Color for the title
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    content: Column(
      children: [
        Icon(icon, color: Colors.red, size: 50),
        const SizedBox(height: 10),
        Text(
          errorMessage.tr,
          style: const TextStyle(fontSize: 18, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    radius: 15,
    backgroundColor: Colors.white,
    barrierDismissible: false,
    confirm: ElevatedButton(
      onPressed: () {
        Get.back();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        'موافق',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}

void showSuccessToast(
  String successMessage,
  // You can change the icon if needed
) {
  Get.defaultDialog(
    title: "تم",
    titleStyle: TextStyle(
      color: Colors.green, // Color for the title
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    content: Column(
      children: [
        Icon(Icons.check_circle_outline, color: Colors.green, size: 50),
        const SizedBox(height: 10),
        Text(
          successMessage.tr,
          style: const TextStyle(fontSize: 18, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    radius: 15,
    backgroundColor: Colors.white,
    barrierDismissible: false,
    confirm: ElevatedButton(
      onPressed: () {
        Get.back();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        'موافق',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}

class CustomDropdownFormField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(T?)? validator;
  final T? initialValue; // ✅ renamed from `value` to `initialValue`

  const CustomDropdownFormField({
    super.key,
    required this.items,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
    this.initialValue, // ✅ also here
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: initialValue, // ✅ use it here
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.blue),
        filled: true,
        fillColor: const Color(0xFFF5F8FB),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}

Widget infoRowWidget(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
