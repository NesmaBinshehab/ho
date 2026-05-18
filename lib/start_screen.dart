import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:honnyapp/admin_web/screens/admin_login.dart';
import 'package:honnyapp/core/constants/app_colors.dart';
import 'package:honnyapp/customer_app/screens/%20login_screen.dart';



class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.continarColor,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              /// اسم المشروع
              Text(
                "HONNY APP",

                style: GoogleFonts.poppins(
                  color: AppColors.white70,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "اختر كيف تريد المتابعة",

                style: GoogleFonts.poppins(
                  color: AppColors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 60),

              /// زر المستخدم
              buildButton(
                context: context,
                title: "استمرار كمستخدم",
                icon: Icons.person,
                color: AppColors.honeyYellow,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              /// زر الادمن
              buildButton(
                context: context,
                title: "استمرار كمدير",
                icon: Icons.admin_panel_settings,
                color: AppColors.blueColor,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AdminLoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 65,

      child: ElevatedButton.icon(
        onPressed: onTap,

        icon: Icon(icon, color: AppColors.white),

        label: Text(
          title,

          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: color,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}