import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String id;
  String name;
  String email;
  String? profileImagePath;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImagePath,
  });

  Future<void> saveProfileImage(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${id}_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedFile = await imageFile.copy('${directory.path}/$fileName');
      
      profileImagePath = savedFile.path;
      
      // Сохраняем путь в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_$id', profileImagePath!);
    } catch (e) {
      debugPrint('Ошибка сохранения изображения: $e');
    }
  }

  static Future<UserModel?> loadUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Загрузка базовой информации о пользователе
    final name = prefs.getString('user_name_$userId');
    final email = prefs.getString('user_email_$userId');
    final imagePath = prefs.getString('profile_image_$userId');

    if (name != null && email != null) {
      return UserModel(
        id: userId,
        name: name,
        email: email,
        profileImagePath: imagePath,
      );
    }

    return null;
  }

  Future<void> saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name_$id', name);
    await prefs.setString('user_email_$id', email);
    if (profileImagePath != null) {
      await prefs.setString('profile_image_$id', profileImagePath!);
    }
  }
}
