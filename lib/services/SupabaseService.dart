import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  // Current User
  User? get currentUser => _client.auth.currentUser;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  // Sign Up
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );

      final user = response.user;

      if (user == null) {
        throw Exception('فشل إنشاء الحساب');
      }

    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('already registered')) {
        throw Exception('هذا البريد مسجل بالفعل');
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception('حدث خطأ أثناء إنشاء الحساب');
    }
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        throw Exception('فشل تسجيل الدخول');
      }

    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('invalid login credentials')) {
        throw Exception('البريد أو كلمة المرور غير صحيحة');
      }
      throw Exception(e.message);
    } catch (_) {
      throw Exception('حدث خطأ أثناء تسجيل الدخول');
    }
  }

  // Logout
  Future<void> logout() async {
    await _client.auth.signOut();
  }
  // Get User Name
  Future<String?> fetchUserName() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    return user.userMetadata?['name'];
  }

}
