import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:honnyapp/core/constants/app_colors.dart';
// import 'package:honnyapp/core/constants/app_strings.dart';
// import 'package:honnyapp/core/constants/app_colors.dart';
import 'package:honnyapp/customer_app/screens/profile_screen.dart';

class ProfileUserInfoScreen extends StatefulWidget {
  const ProfileUserInfoScreen({super.key});

  @override
  State<ProfileUserInfoScreen> createState() =>
      _ProfileUserInfoScreenState();
}

class _ProfileUserInfoScreenState
    extends State<ProfileUserInfoScreen> {

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
saveUserData() async {

  try {

    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("User not logged in"),
        ),
      );

      setState(() {
        isLoading = false;
      });

      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({

      'uid': user.uid,
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'role': 'customer',
      'image': '',

    });

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );

  } catch (e) {

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        content: Text("Error: $e"),
      ),
    );

    print(e);
  }
}
  InputDecoration modernInput({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(

      hintText: hint,

      hintStyle: GoogleFonts.poppins(
        color: AppColors.white70,
        fontSize: 14,
      ),

      prefixIcon: Icon(
        icon,
        color: AppColors.white,
      ),

      filled: true,

      fillColor: AppColors.white5,

      contentPadding: const EdgeInsets.symmetric(
        vertical: 20,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColors.white5,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.honeyYellow,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          
            color: AppColors.continarColor,
              
          
        ),

        child: SafeArea(

          child: Stack(

            children: [

              /// خلفيات دائرية
              Positioned(
                top: -80,
                right: -50,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white5,
                  ),
                ),
              ),

              Positioned(
                bottom: -190,
                left: -56,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.honeyYellow,
                  ),
                ),
              ),

              SingleChildScrollView(

                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),

                child: Form(

                  key: _formKey,

                  child: Column(

                    children: [

                      const SizedBox(height: 20),

                      /// الصورة
                      Container(

                        padding: const EdgeInsets.all(5),

                    
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: AppColors.honeyYellow,

                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Text(
                        "ادخل معلوماتك",

                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                  

                      const SizedBox(height: 40),

                      /// Glass Container
                      ClipRRect(

                        borderRadius: BorderRadius.circular(30),

                        child: BackdropFilter(

                          filter: ImageFilter.blur(
                            sigmaX: 20,
                            sigmaY: 20,
                          ),

                          child: Container(

                            padding: const EdgeInsets.all(25),

                            decoration: BoxDecoration(

                              borderRadius:
                                  BorderRadius.circular(30),

                              color: AppColors.white5,

                              border: Border.all(
                                color: AppColors.white5,
                              ),
                            ),

                            child: Column(

                              children: [

                                /// الاسم
                                TextFormField(

                                  controller: nameController,

                                  validator: (value) {

                                    if (value == null ||
                                        value.trim().isEmpty) {

                                      return "Enter your name";
                                    }

                                    return null;
                                  },

                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),

                                  decoration: modernInput(
                                    hint: "الاسم الكامل",
                                    icon: Icons.person,
                                  ),
                                ),

                                const SizedBox(height: 22),

                                /// الهاتف
                                TextFormField(

                                  controller: phoneController,

                                  keyboardType:
                                      TextInputType.phone,

                                  validator: (value) {

                                    if (value == null ||
                                        value.trim().isEmpty) {

                                      return "Enter your phone";
                                    }

                                    return null;
                                  },

                                  style: const TextStyle(
                                    color: AppColors.white,
                                  ),

                                  decoration: modernInput(
                                    hint: "رقم الهاتف",
                                    icon: Icons.phone,
                                  ),
                                ),

                                const SizedBox(height: 22),

                                /// العنوان
                                TextFormField(

                                  controller: addressController,

                                  validator: (value) {

                                    if (value == null ||
                                        value.trim().isEmpty) {

                                      return "Enter your address";
                                    }

                                    return null;
                                  },

                                  style: const TextStyle(
                                    color: AppColors.white,
                                  ),

                                  decoration: modernInput(
                                    hint: "العنوان",
                                    icon: Icons.location_on,
                                  ),
                                ),

                                const SizedBox(height: 35),

                                /// زر الحفظ
                                SizedBox(

                                  width: double.infinity,
                                  height: 58,

                                  child: ElevatedButton(

                                    onPressed: () {

                                      if (_formKey.currentState!
                                          .validate()) {

                                        saveUserData();
                                      }
                                    },

                                    style: ElevatedButton.styleFrom(

                                      backgroundColor:
                                          AppColors.honeyYellow,

                                      elevation: 10,

                                      shadowColor:
                                          AppColors.borderColor,

                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18),
                                      ),
                                    ),

                                    child: isLoading

                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,

                                            child:
                                                CircularProgressIndicator(
                                              color: AppColors.blueColor,
                                              strokeWidth: 2,
                                            ),
                                          )

                                        : Text(

                                            "احفظ ",

                                            style:
                                                GoogleFonts.poppins(
                                              color: AppColors.white70,
                                              fontSize: 17,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}