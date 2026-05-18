import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:honnyapp/core/constants/app_colors.dart';
import 'package:honnyapp/core/constants/app_strings.dart';
import 'package:honnyapp/customer_app/controllers/auth_controller.dart';
import 'package:honnyapp/customer_app/screens/Profile_user_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name = "", email = "", password = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final AuthController authController = AuthController();

  bool isLoading = false;

  regisaration() async {
    if (password.isNotEmpty &&
        nameController.text != "" &&
        emailController.text != "") {
      setState(() {
        isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
              "uid": userCredential.user!.uid,

              "name": nameController.text.trim(),

              "email": emailController.text.trim(),

              "role": "customer",

              "createdAt": DateTime.now(),
            });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Registration successful",
              style: TextStyle(color: AppColors.white, fontSize: 20.0),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileUserInfoScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = "An error occurred during registration.";

        if (e.code == 'email-already-in-use') {
          errorMessage = "The email address is already in use.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "The email address is invalid.";
        } else if (e.code == 'weak-password') {
          errorMessage = "The password is too weak.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: const TextStyle(color: AppColors.white, fontSize: 20.0),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "An unexpected error occurred.",
              style: TextStyle(color: AppColors.white, fontSize: 20.0),
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }
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
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  const SizedBox(height: 60),

                  Center(
                    child: Icon(
                      Icons.hive,
                      color: AppColors.honeyYellow,
                      size: 90,
                    ),
                  ),

                  const SizedBox(height: 35),

                  Text(
                    AppStrings.createAccountTitle,

                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    AppStrings.createAccountSubtitle,

                    style: GoogleFonts.poppins(
                      color: AppColors.grey,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 40),
                  //forms
                  Form(
                    key: _formkey,

                    child: Column(
                      children: [
                        // NAME FIELD
                        TextFormField(
                          controller: nameController,

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your name";
                            }

                            return null;
                          },

                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                          ),

                          decoration: InputDecoration(
                            hintText: AppStrings.fullName,

                            hintStyle: const TextStyle(color: AppColors.grey),

                            prefixIcon: const Icon(
                              Icons.person,
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

                        // EMAIL FIELD
                        TextFormField(
                          controller: emailController,

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your email";
                            }

                            return null;
                          },

                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                          ),

                          decoration: InputDecoration(
                            hintText: AppStrings.email,

                            hintStyle: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),

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

                        // PASSWORD FIELD
                        TextFormField(
                          controller: passwordController,

                          obscureText: true,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }

                            return null;
                          },

                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                          ),

                          decoration: InputDecoration(
                            hintText: AppStrings.password,

                            hintStyle: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),

                            prefixIcon: const Icon(
                              Icons.lock,
                              color: AppColors.honeyYellow,
                            ),

                            filled: true,

                            fillColor: AppColors.fieldColor,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // SIGNUP BUTTON
                  GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          name = nameController.text;
                          email = emailController.text;
                          password = passwordController.text;
                        });

                        regisaration();
                      }
                    },

                    child: SizedBox(
                      width: double.infinity,

                      height: 45,

                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              name = nameController.text;
                              email = emailController.text;
                              password = passwordController.text;
                            });

                            regisaration();
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.honeyYellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),

                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                AppStrings.signUp,

                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        AppStrings.alreadyHaveAccount,

                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: Text(
                          AppStrings.login,

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
