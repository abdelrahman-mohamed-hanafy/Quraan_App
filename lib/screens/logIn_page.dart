import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/Custom%20widget/CustomInputField.dart';
import 'package:quraan/controllers/LoginController.dart';
import 'package:quraan/states/LoginStates.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B2F23),
                Color(0xFF0E3A2C),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // ⭐ Logo
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFD4AF37),
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 56,
                          color: Color(0xFFD4AF37),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'القرآن الكريم',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'AL-QURAN AL-KAREEM',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 36),

                      const Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 36),

                      // 🔹 Email
                      CustomInputField(
                        controller: controller.emailController,
                        hint: 'البريد الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // 🔹 Password
                      Obx(() => CustomInputField(
                        controller: controller.passwordController,
                        hint: 'كلمة المرور',
                        obscure: controller.isPasswordHidden.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      )),
                      const SizedBox(height: 28),

                      // 🔹 STATE HANDLING + زرار الدخول + عرض الخطأ
                      Obx(() {
                        final state = controller.state.value;

                        // لو فيه خطأ
                        Widget errorWidget = SizedBox.shrink();
                        if (state is LoginError || state is LoginValidationError) {
                          errorWidget = Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              (state as dynamic).message,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            errorWidget,
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: state is LoginLoading
                                    ? null
                                    : () async {
                                  FocusScope.of(context).unfocus();
                                  await controller.login();
                                  // بعد النجاح نروح على الهوم
                                  if (controller.state.value is LoginSuccess) {
                                    Get.offNamed('/home');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4AF37),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: state is LoginLoading
                                    ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                                    : const Text(
                                  'دخول',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.offNamed('/Sign');
                            },
                            child: const Text(
                              'تسجيل حساب',
                              style: TextStyle(fontSize: 15, color: Colors.red),
                            ),
                          ),
                          const Text(
                            'ليس لدى حساب',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'تدبر • قراءة • سكينة',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white38,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
