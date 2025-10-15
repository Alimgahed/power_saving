import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/auth/all_user.dart';
import 'package:power_saving/model/login.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AllUserScreen extends StatelessWidget {
  const AllUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllUserController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Section with Gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
               
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.people,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إدارة المستخدمين',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'عرض وتعديل بيانات المستخدمين',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Refresh Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => controller.loadUsers(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: const Row(
                          children: [
                            Icon(Icons.refresh, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'تحديث',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                 IconButton(
                  onPressed: () => Get.offNamed("./home"),
                  icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          
          // Content Section
          Expanded(
            child: Obx(() {
              if (controller.users.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person_off_outlined,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'لا يوجد مستخدمين',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لم يتم العثور على أي بيانات',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                );
              }
          
              return Padding(
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: List.generate(controller.users.length, (index) {
                      final user = controller.users[index];
                            
                      return Container(
                        width: 380,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _showEditDialog(context, controller, index, user),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.blue.shade400, Colors.blue.shade700],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    
                                    // User Info
                                    Text(
                                      user.empName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    Spacer(),
                                    // Status Toggle
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: user.isActive 
                                          ? Colors.green.shade50 
                                          : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: user.isActive 
                                            ? Colors.green.shade200 
                                            : Colors.red.shade200,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            user.isActive ? 'نشط' : 'غير نشط',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: user.isActive 
                                                ? Colors.green.shade700 
                                                : Colors.red.shade700,
                                            ),
                                          ),
                                        
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Divider
                                Divider(color: Colors.grey.shade200, thickness: 1),
                                
                                const SizedBox(height: 20),
                                
                                // User Details
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.badge_outlined,
                                        label: 'كود الموظف',
                                        value: user.empCode,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.group_outlined,
                                        label: 'المجموعة',
                                        value: user.groupName??"",
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Edit Button
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade600, Colors.blue.shade800],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () => _showEditDialog(context, controller, index, user),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.edit, color: Colors.white, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              'تعديل البيانات',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    }),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, AllUserController controller, int index, User user) {
    final nameController = TextEditingController(text: user.empName);
    final usernameController = TextEditingController(text: user.username);
    final empCodeController = TextEditingController(text: user.empCode);
    int groupIdController =  user.groupId!;
    final groupNameController = TextEditingController(text: user.groupName);
    final isActiveNotifier = ValueNotifier<bool>(user.isActive);

    showDialog(
      context: context,
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade600, Colors.blue.shade800],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 28),
                          SizedBox(width: 12),
                          Text(
                            'تعديل بيانات المستخدم',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Form
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller: empCodeController,
                            label: 'كود الموظف',
                            icon: Icons.badge_outlined,
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: nameController,
                            label: 'اسم الموظف',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: usernameController,
                            label: 'اسم المستخدم',
                            icon: Icons.alternate_email,
                          ),
                          const SizedBox(height: 8),
                           Text(
          "كود المجموعة",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
          const SizedBox(height: 16),
                          CustomDropdownFormField<int>(
                            initialValue: user.groupId,
                                  items: [
                                    const DropdownMenuItem(
                                      value: 1,
                                      child: Text("تكنولوجيا المعلومات"),
                                    ),
                                    const DropdownMenuItem(
                                      value: 2,
                                      child: Text("المكتب الفني"),
                                    ),
                                     const DropdownMenuItem(
                                      value: 3,
                                      child: Text("الترشيد والطاقة"),
                                    ),
                                    const DropdownMenuItem(
                                      value: 4,
                                      child: Text("المعامل"),
                                    ),
                                  ],
                                  onChanged: (val) {
                                  groupIdController=val!;
                                  },
                                  labelText: 'الترشيد والطاقة',
                                  hintText: 'الادارة',
                                  prefixIcon: Icons.category,
                                  validator:
                                      (val) =>
                                          val == null
                                              ? 'الرجاء اختيار نوع المحطة'
                                              : null,
                                ),
                        
                          const SizedBox(height: 8),
                          
                          // Active Status Toggle
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: ValueListenableBuilder<bool>(
                              valueListenable: isActiveNotifier,
                              builder: (context, isActive, _) {
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.toggle_on_outlined,
                                      color: Colors.blue.shade600,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'حالة المستخدم',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isActive 
                                          ? Colors.green.shade50 
                                          : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isActive 
                                            ? Colors.green.shade200 
                                            : Colors.red.shade200,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        isActive ? 'نشط' : 'غير نشط',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isActive 
                                            ? Colors.green.shade700 
                                            : Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Switch(
                                      value: isActive,
                                      activeColor: Colors.green.shade600,
                                      inactiveThumbColor: Colors.red.shade400,
                                      onChanged: (value) {
                                        isActiveNotifier.value = value;
                                      },
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                 Obx(() => Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  focusColor:  Colors.green,
                  activeColor: Colors.green,
                  value: controller.resetPassword.value,
                  onChanged: (value) {
                    controller.resetPassword.value = value!;
                  },
                ),
                const Text('إعادة تعيين كلمة المرور'),
              ],
            )),
      
                                  ],
                                );
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Buttons
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () => Get.back(),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        child: Text(
                                          'إلغاء',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade600, Colors.blue.shade800],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        final editedUser = User(
                                          empCode: empCodeController.text,
                                          empName: nameController.text,
                                          groupId: groupIdController,
                                          isActive: isActiveNotifier.value,
                                          username: usernameController.text,
                                          reset:controller.resetPassword.value
                                        );
                                        controller.editUser(index, editedUser);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        child: 
                                     Obx((){
                                      return
                                      controller.isLoading.value?Center(child: CircularProgressIndicator(),):Text(
                                          'حفظ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                     })    
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.blue.shade600, size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}