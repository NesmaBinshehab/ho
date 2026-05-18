import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:honnyapp/core/constants/app_colors.dart';
import 'admin_home.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;

  /// كلمة المرور الصحيحة
  final String adminPassword = "123456";

  Future<void> loginAdmin() async {
    if (passwordController.text.trim() == adminPassword) {
      SharedPreferences prefs =
          await SharedPreferences.getInstance();

      /// تخزين كلمة المرور
      await prefs.setString(
        'admin_password',
        passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminHome(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("كلمة المرور غير صحيحة"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightYellow,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Container(
            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              color: AppColors.continarColor,
              borderRadius: BorderRadius.circular(25),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  " مرحبا بك",

                  style: GoogleFonts.poppins(
                    color: AppColors.honeyYellow,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "سجل دخولك كمسؤول",

                  style: GoogleFonts.poppins(
                    color: AppColors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 35),

                TextField(
                  controller: passwordController,
                  obscureText: true,

                  style: const TextStyle(color: AppColors.white),

                  decoration: InputDecoration(
                    hintText: "ادخل كلمة المرور",
                    hintStyle:
                        const TextStyle(color: AppColors.white70),

                    filled: true,
                    fillColor: AppColors.white5,

                    prefixIcon: const Icon(
                      Icons.lock,
                      color: AppColors.honeyYellow,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(18),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: loginAdmin,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.honeyYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),

                    child: Text(
                      "سجل الدخول",

                      style: GoogleFonts.poppins(
                        color: AppColors.continarColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
  }
}