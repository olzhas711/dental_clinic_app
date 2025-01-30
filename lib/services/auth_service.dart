import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<bool> signUp(
      {required String phone,
      required String password,
      String fullName = '',
      String role = 'patient'}) async {
    try {
      // Регистрация пользователя
      final authResponse = await _supabase.auth.signUp(
          phone: '+7$phone',
          password: password,
          data: {'full_name': fullName, 'role': role});

      return authResponse.user != null;
    } catch (e) {
      print('Ошибка регистрации: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> signIn(
      {required String phone, required String password}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        phone: '+7$phone',
        password: password,
      );

      if (response.user == null) return null;

      // Получаем профиль пользователя
      final profile = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return {'user': response.user, 'profile': profile};
    } catch (e) {
      print('Ошибка входа: $e');
      return null;
    }
  }

  // Отправить OTP на номер телефона
  Future<bool> sendOTP(String phone) async {
    try {
      await _supabase.auth.signInWithOtp(
        phone: '+7$phone',
        // Можно настроить дополнительные параметры
        shouldCreateUser: true,
      );
      return true;
    } catch (e) {
      print('Ошибка отправки OTP: $e');
      return false;
    }
  }

  // Подтвердить OTP
  Future<Map<String, dynamic>?> verifyOTP({
    required String phone, 
    required String token
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        phone: '+7$phone',
        token: token,
        type: OtpType.sms,
      );

      if (response.user == null) return null;

      // Получаем профиль пользователя
      final profile = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return {
        'user': response.user,
        'profile': profile
      };
    } catch (e) {
      print('Ошибка подтверждения OTP: $e');
      return null;
    }
  }

  Future<String?> getUserRole() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single();

    return response['role'];
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
