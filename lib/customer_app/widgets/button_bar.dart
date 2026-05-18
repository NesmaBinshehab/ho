import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:honnyapp/core/constants/app_colors.dart';

class CustomNavBar extends StatefulWidget {
  final Function(int) onPageChanged; // دالة لإخبار الصفحة الرئيسية بتغير الصفحة

  const CustomNavBar({super.key, required this.onPageChanged});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 70.0,
      index: 0,
      items: <Widget>[
        Icon(
          Icons.home_outlined,
          size: 30,
          color: _currentIndex == 0 ? AppColors.blackColor : AppColors.grey,
        ),
        Icon(
          Icons.production_quantity_limits,
          size: 30,
          color: _currentIndex == 1 ? AppColors.blackColor : AppColors.grey,
        ),
        Icon(
          Icons.shopping_cart_rounded,
          size: 30,
          color: _currentIndex == 2 ? AppColors.blackColor : AppColors.grey,
        ),
        Icon(
          Icons.person_outline,
          size: 30,
          color: _currentIndex == 3 ? AppColors.blackColor : AppColors.grey,
        ),
      ],
      color: const Color(0xFF1A1A1A), // لون الشريط (أسود)
      buttonBackgroundColor: AppColors.honeyYellow, // لون الكرة (أخضر)
      backgroundColor: Colors.transparent, // شفاف ليظهر لون الخلفية من تحته
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        widget.onPageChanged(index); // نمرر الرقم الجديد للملف الرئيسي
      },
    );
  }
}
