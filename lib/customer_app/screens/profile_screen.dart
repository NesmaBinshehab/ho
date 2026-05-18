import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:honnyapp/core/constants/app_colors.dart';
// import 'package:honnyapp/core/constants/app_strings.dart';
import 'cart_screen.dart';
import 'order_tracking_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.continarColor,

      body: SafeArea(
        child: user == null
            ? const Center(
                child: Text(
                  "المستخدم غير موجود",
                  style: TextStyle(color: AppColors.white),
                ),
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                      child: Text(
                        "لا توجد بيانات لهذا المستخدم",
                        style: TextStyle(color: AppColors.white),
                      ),
                    );
                  }

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  String name = (data['name'] ?? '').toString();

                  String email = user.email ?? "No Email";
                  String phone = (data['phone'] ?? '').toString();

                  String address = (data['address'] ?? '').toString();

                  return Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        Text(
                          "حسابي ",

                          style: GoogleFonts.poppins(
                            color: AppColors.continarColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        
                        /// CARD
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),

                              decoration: BoxDecoration(
                                color: AppColors.white5,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: AppColors.white5,
                                  width: 1.2,
                                ),
                              ),

                              child: Column(
                                children: [
                                  const CircleAvatar(
                                    radius: 45,
                                    backgroundColor: AppColors.honeyYellow,
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppColors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  Text(
                                    name.isEmpty ? "User" : name,

                                    style: GoogleFonts.poppins(
                                      color: AppColors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    email.isEmpty ? "لا يوجد بريد إلكتروني" : email,

                                    style: GoogleFonts.poppins(
                                      color: AppColors.white70,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 25),

                                  buildTile(
                                    Icons.phone,
                                    phone.isEmpty ? "لا يوجد رقم هاتف" : phone,
                                  ),

                                  const SizedBox(height: 15),

                                  buildTile(
                                    Icons.location_on,
                                    address.isEmpty ? "لا يوجد عنوان" : address,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        /// BUTTONS
                        Row(
                          children: [
                            Expanded(
                              
                              child: buildButton(
                                title: "السلة",

                                icon: Icons.shopping_cart,
 
                                color: AppColors.honeyYellow,

                                onTap: () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) => const CartScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: buildButton(
                                title: "تتبع الطلب",

                                icon: Icons.local_shipping,

                                color: AppColors.blueColor,

                                onTap: () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const OrderTrackingScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget buildTile(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color:  AppColors.white5,

        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [
          Icon(icon, color: AppColors.honeyYellow),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              text,

              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 110,

        decoration: BoxDecoration(
          color:  AppColors.white5,

          borderRadius: BorderRadius.circular(22),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, color: color, size: 35),

            const SizedBox(height: 10),

            Text(
              title,

              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
