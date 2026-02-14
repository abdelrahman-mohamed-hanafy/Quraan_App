import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/services/SupabaseService.dart';
import 'package:quraan/states/LoginStates.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final userService = Get.find<UserService>();

  final isPasswordHidden = true.obs;
  final state = Rx<LoginState>(LoginInitial());

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      state.value = LoginValidationError('من فضلك املأ جميع البيانات');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      state.value = LoginValidationError('البريد الإلكتروني غير صالح');
      return;
    }

    try {
      state.value = LoginLoading();

      await userService.login(
        email: email,
        password: password,
      );

      state.value = LoginSuccess(
        message: 'تم تسجيل الدخول بنجاح',
      );

    } catch (e) {
      state.value = LoginError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(state, (value) {
      if (value is LoginSuccess) {
        Get.offNamed('/home');
      }
    });
    emailController.addListener(_resetState);
    passwordController.addListener(_resetState);
  }


  void _resetState() {
    if (state.value is LoginError ||
        state.value is LoginValidationError) {
      state.value = LoginInitial();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

