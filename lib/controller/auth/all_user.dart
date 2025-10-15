import 'dart:convert';
import 'package:get/get.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/login.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/network/network.dart';
import 'package:flutter/material.dart';

class AllUserController extends GetxController {
  var users = <User>[].obs;
    RxBool resetPassword = false.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  /// Load all users from API
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      users.value = [];

      final res = await fetchData("http://$ip/all-users");

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        
        // Check if response is a list
        if (jsonData is List) {
          users.value = jsonData.map((user) => User.fromJson(user)).toList();
        } else if (jsonData['users'] != null) {
          // If response has 'users' key
          users.value = (jsonData['users'] as List)
              .map((user) => User.fromJson(user))
              .toList();
        } else {
          // Single user object
          users.value = [User.fromJson(jsonData)];
        }

      } 
    } catch (e) {
      errorMessage.value = 'خطأ في الاتصال: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle user active status
  Future<void> toggleActive(int index) async {
    if (index < 0 || index >= users.length) return;

    try {
      final user = users[index];
      final newStatus = !user.isActive;

      // Optimistic update
      users[index] = User(
        empCode: user.empCode,
        empName: user.empName,
        groupId: user.groupId,
        groupName: user.groupName,
        isActive: newStatus,
        username: user.username,
      );
      users.refresh();

      // // Send update to API
      // final res = await fetchData(
      //   "http://$ip/toggle-user-status",
      //   method: 'POST',
      //   body: json.encode({
      //     'empCode': user.empCode,
      //     'isActive': newStatus,
      //   }),
      // );

      // if (res.statusCode == 200) {
      //   _showSuccessSnackbar(
      //     'تم التحديث',
      //     'تم ${newStatus ? "تفعيل" : "تعطيل"} المستخدم بنجاح',
      //   );
      // } else {
      //   // Revert on failure
      //   users[index] = user;
      //   users.refresh();
      //   _showErrorSnackbar('خطأ', 'فشل في تحديث حالة المستخدم');
      // }
    } catch (e) {
      // Revert on error
      loadUsers();
      print('Error toggling status: $e');
    }
  }


  /// Edit user information
  Future<void> editUser(int index, User editedUser) async {
    if (index < 0 || index >= users.length) return;

      try {
    isLoading.value = true;

   final res = await postData(
  "http://$ip/edit-user/${editedUser.empCode}",
  
    editedUser.toJson()
   
  );
      users.refresh();

      // Send update to API
      // final res = await fetchData(
      //   "http://$ip/update-user",
      //   method: 'PUT',
      //   body: json.encode({
      //     'empCode': editedUser.empCode,
      //     'empName': editedUser.empName,
      //     'username': editedUser.username,
      //     'groupId': editedUser.groupId,
      //     'isActive': editedUser.isActive,
      //   }),
      // );

      if (res.statusCode == 200) {
        isLoading.value=false;
        showSuccessToast('تم تحديث بيانات المستخدم بنجاح');
        loadUsers();
      } else {
                isLoading.value=false;

showCustomErrorDialog(errorMessage: "خطأ");   
      }
    } catch (e) {
      showCustomErrorDialog(errorMessage: "خطأ");   

      // Revert on error
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete user
  Future<void> deleteUser(int index) async {
    if (index < 0 || index >= users.length) return;

    try {
      final user = users[index];
      
      // Show confirmation dialog
      final confirm = await Get.dialog<bool>(
        Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 28),
                const SizedBox(width: 12),
                const Text('تأكيد الحذف'),
              ],
            ),
            content: Text(
              'هل أنت متأكد من حذف المستخدم "${user.empName}"؟',
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'إلغاء',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('حذف', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      );

      if (confirm != true) return;

      isLoading.value = true;
      
      // Remove from list
      users.removeAt(index);
      users.refresh();

      // Send delete request to API
      // final res = await fetchData(
      //   "http://$ip/delete-user/${user.empCode}",
      //   method: 'DELETE',
      // );

      // if (res.statusCode == 200) {
      //   _showSuccessSnackbar('تم الحذف', 'تم حذف المستخدم بنجاح');
      // } else {
      //   // Reload on failure
      //   loadUsers();
      //   _showErrorSnackbar('خطأ', 'فشل في حذف المستخدم');
      // }
    } catch (e) {
      // Reload on error
    } finally {
      isLoading.value = false;
    }
  }

  /// Search/Filter users
  List<User> filterUsers(String query) {
    if (query.isEmpty) return users;

    return users.where((user) {
      return user.empName.toLowerCase().contains(query.toLowerCase()) ||
          user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.empCode.toLowerCase().contains(query.toLowerCase());
       
    }).toList();
  }

  /// Get active users count
  int get activeUsersCount => users.where((user) => user.isActive).length;

  /// Get inactive users count
  int get inactiveUsersCount => users.where((user) => !user.isActive).length;

  /// Success Snackbar

}
  /// Error Snackbar
