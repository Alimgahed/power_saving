import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  bool? readonly=false;
  Function()? onTap;
  final bool allowOnlyDigits;
  final bool useValidator; // <-- NEW

   CustomTextFormField({
    super.key,
    this.label,
     this.readonly,
    this.onTap,
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
        onTap:onTap,
        controller: controller,
        readOnly: readonly??false,
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
// Updated Controller
class SearchableDropdownController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  
  RxList<DropdownMenuItem<String>> filteredItems = <DropdownMenuItem<String>>[].obs;
  RxList<DropdownMenuItem<String>> allItems = <DropdownMenuItem<String>>[].obs;
  RxBool isDropdownOpen = false.obs;
  RxString selectedValue = ''.obs;
  RxString selectedText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Listen to search text changes
    searchController.addListener(() {
      filterItems(searchController.text);
    });
    
    // Listen to focus changes
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        openDropdown();
      }
    });
  }

  void initializeItems(List<DropdownMenuItem<String>> items, String? initialValue) {
    allItems.value = items;
    filteredItems.value = items;
    
    if (initialValue != null && initialValue.isNotEmpty) {
      selectedValue.value = initialValue;
      final selectedItem = items.firstWhereOrNull(
        (item) => item.value == initialValue,
      );
      if (selectedItem != null) {
        selectedText.value = (selectedItem.child as Text).data ?? '';
        searchController.text = selectedText.value;
      }
    }
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      filteredItems.value = allItems;
    } else {
      filteredItems.value = allItems.where((item) {
        final text = (item.child as Text).data?.toLowerCase() ?? '';
        return text.contains(query.toLowerCase());
      }).toList();
    }
  }

  void openDropdown() {
    isDropdownOpen.value = true;
  }

  void closeDropdown() {
    isDropdownOpen.value = false;
    focusNode.unfocus();
  }

  void selectItem(String? value, String text) {
    selectedValue.value = value ?? '';
    selectedText.value = text;
    searchController.text = text;
    closeDropdown();
  }

  void clearSelection() {
    selectedValue.value = '';
    selectedText.value = '';
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}

// Updated Widget
class SearchableDropdown extends StatelessWidget {
  final List<DropdownMenuItem<String>> items;
  final String? initialValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final String tag;

  const SearchableDropdown({
    Key? key,
    required this.items,
    this.initialValue,
    required this.onChanged,
    this.validator,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.tag = 'searchable_dropdown',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchableDropdownController(), tag: tag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeItems(items, initialValue);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller.searchController,
          focusNode: controller.focusNode,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.blue) : null,
            suffixIcon: Obx(() => IconButton(
              icon: Icon(
                controller.isDropdownOpen.value
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onPressed: () {
                if (controller.isDropdownOpen.value) {
                  controller.closeDropdown();
                } else {
                  controller.openDropdown();
                  controller.focusNode.requestFocus();
                }
              },
            )),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color:  Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelStyle: TextStyle(color: Colors.black, fontSize: 12),
          ),
          validator: (value) {
            if (validator != null) {
              return validator!(controller.selectedValue.value);
            }
            return null;
          },
          onTap: () {
            controller.openDropdown();
          },
        ),

        Obx(() => controller.isDropdownOpen.value
            ? Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                constraints: BoxConstraints(maxHeight: 250),
                child: controller.filteredItems.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'لا يوجد'.tr,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: controller.filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = controller.filteredItems[index];
                          final text = (item.child as Text).data ?? '';
                          final isSelected = controller.selectedValue.value == item.value;

                          return InkWell(
                            onTap: () {
                              controller.selectItem(item.value, text);
                              onChanged(item.value);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: isSelected ?  Colors.blue : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      color:  Colors.blue,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            : SizedBox.shrink()),
      ],
    );
  }
}

// Usage Example - Updated to work with integer IDs

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
