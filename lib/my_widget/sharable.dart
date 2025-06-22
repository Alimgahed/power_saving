import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool allowOnlyDigits;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.allowOnlyDigits = false,
    this.icon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType:
            allowOnlyDigits ? TextInputType.number : TextInputType.text,
        inputFormatters:
            allowOnlyDigits
                ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(
                      r'^\d*\.?\d*$',
                    ), // Allow digits and optional decimal point
                  ),
                ]
                : null,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.blue),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
      ),
    );
  }
}

Widget DropdownFormField<T>({
  required List<DropdownMenuItem<T>> items,
  required void Function(T?) onChanged,
  T? initialValue,
  required String labelText,
  required String hintText,
  IconData? prefixIcon,
  IconData? dropdownIcon,
  Color? iconEnabledColor,
  String? Function(T?)? validator,
  bool useValidator = true,
}) {
  return DropdownButtonFormField<T>(
    value: initialValue,
    items: items,
    onChanged: onChanged,
    validator:
        useValidator
            ? validator ??
                (value) {
                  if (value == null) {
                    return 'This field cannot be empty';
                  } else {
                    return null;
                  }
                }
            : null,
    icon: dropdownIcon != null ? Icon(dropdownIcon) : null,
    iconEnabledColor: iconEnabledColor,
    iconDisabledColor: Colors.blue,
    decoration: InputDecoration(
      hoverColor: Colors.white,
      focusColor: Colors.white,

      // Optional prefixIcon if provided
      prefixIcon:
          prefixIcon != null
              ? Icon(prefixIcon, color: Color(0xFF000C3E))
              : null,

      fillColor: Colors.white, // Fill color for the dropdown
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      // Ensure labelText and hintText are added correctly
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 14, // Slightly larger font size for better visibility
      ),
      labelText: labelText, // Display the label text
      hintText: hintText, // Display the hint text
    ),
  );
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

void showSuccessToast(String message) {
  Get.snackbar(
    'تم', // Title of the snackbar (can be omitted or localized)
    message, // The message to show
    snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
    backgroundColor: Colors.green, // Background color
    colorText: Colors.white, // Text color
    duration: const Duration(
      seconds: 2,
    ), // Duration for how long it should be displayed
    margin: const EdgeInsets.all(10), // Margin around the snackbar
    borderRadius: 8, // Border radius
    icon: const Icon(Icons.check_circle, color: Colors.white), // Optional icon
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
