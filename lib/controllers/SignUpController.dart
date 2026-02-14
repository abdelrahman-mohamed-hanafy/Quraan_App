import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/services/SupabaseService.dart';
import 'package:quraan/states/SignUpStates.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final userService = Get.find<UserService>();

  final isPasswordHidden = true.obs;
  final state = Rx<SignUpState>(SignUpInitial());

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      state.value = SignUpValidationError('من فضلك املأ جميع البيانات');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      state.value = SignUpValidationError('البريد الإلكتروني غير صالح');
      return;
    }

    if (password.length < 6) {
      state.value =
          SignUpValidationError('كلمة المرور يجب ألا تقل عن 6 أحرف');
      return;
    }

    try {
      state.value = SignUpLoading();

      await userService.signUp(
        email: email,
        password: password,
        name: name,
      );

      state.value = SignUpSuccess(
        message: 'تم إنشاء الحساب بنجاح',
      );

    } catch (e) {
      state.value =
          SignUpError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  void onInit() {
    super.onInit();

    ever(state, (value) {
      if (value is SignUpSuccess) {
        Get.offNamed('/LogIn');
      }
    });

    nameController.addListener(_resetState);
    emailController.addListener(_resetState);
    passwordController.addListener(_resetState);
  }



  void _resetState() {
    if (state.value is SignUpError ||
        state.value is SignUpValidationError) {
      state.value = SignUpInitial();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
