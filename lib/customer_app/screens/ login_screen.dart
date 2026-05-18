import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:honnyapp/core/constants/app_colors.dart';
import 'package:honnyapp/core/constants/app_strings.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:honnyapp/core/services/auth_service.dart';

import 'package:honnyapp/customer_app/screens/Profile_user_info_screen.dart';
import 'package:honnyapp/customer_app/screens/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:honnyapp/customer_app/screens/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// ✅ تسجيل الدخول الصحيح
  ueserLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      /// تسجيل دخول Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      /// جلب بيانات المستخدم من Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      /// ❌ لا يوجد حساب في Firestore
      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("لا يوجد حساب بهذا الاسم"),
          ),
        );

        setState(() {
          isLoading = false;
        });

        return;
      }

      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

      String phone = (data['phone'] ?? '').toString();
      String address = (data['address'] ?? '').toString();

      /// ❗ بيانات ناقصة
      if (phone.isEmpty || address.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileUserInfoScreen(),
          ),
        );
      } else {
        /// ✅ بيانات مكتملة
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = "حدث خطأ";

      if (e.code == 'user-not-found') {
        msg = "لا يوجد حساب بهذا البريد";
      } else if (e.code == 'wrong-password') {
        msg = "كلمة المرور غير صحيحة";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.continarColor,

      body: Directionality(
        textDirection: TextDirection.rtl,

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),

            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80),

                  Icon(Icons.hive, color: AppColors.honeyYellow, size: 90),

                  const SizedBox(height: 40),

                  Text(
                    AppStrings.welcome,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Form(
                    key: _formKey,

                    child: Column(
                      children: [
                        /// EMAIL
                        TextFormField(
                          controller: emailController,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "أدخل الإيميل";
                            }
                            return null;
                          },

                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                          ),

                          decoration: InputDecoration(
                            hintText: AppStrings.email,

                            prefixIcon: const Icon(
                              Icons.email,
                              color: AppColors.honeyYellow,
                            ),

                            filled: true,
                            fillColor: AppColors.fieldColor,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// PASSWORD
                        TextFormField(
                          controller: passwordController,

                          obscureText: true,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "أدخل كلمة المرور";
                            }
                            return null;
                          },

                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                          ),

                          decoration: InputDecoration(
                            hintText: AppStrings.email,

                            prefixIcon: const Icon(
                              Icons.email,
                              color: AppColors.honeyYellow,
                            ),

                            filled: true,
                            fillColor: AppColors.fieldColor,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),

                            /// الحواف العادية
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),

                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                            ),

                            /// عند الضغط على الحقل
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),

                              borderSide: const BorderSide(
                                color: AppColors.honeyYellow,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// زر تسجيل الدخول
                  SizedBox(
                    width: double.infinity,
                    height: 45,

                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text.trim();
                            password = passwordController.text.trim();
                          });

                          ueserLogin();
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.honeyYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              AppStrings.login,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "أو",
                    style: GoogleFonts.poppins(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      AuthService().signInWithGoogle(context);
                    },

                    child: Container(
                      width: 40,
                      height: 40,

                      decoration: BoxDecoration(
                        border: Border.all(
                          // color: const Color.fromARGB(255, 188, 224, 5),
                        ),
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.white,
                      ),

                      child: const Center(
                        child: Icon(
                          Icons.g_mobiledata,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        AppStrings.noAccount,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },

                        child: Text(
                          AppStrings.signUp,
                          style: const TextStyle(
                            color: AppColors.honeyYellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
