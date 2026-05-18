import 'package:flutter/material.dart';
import 'package:honnyapp/core/constants/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool isExpanded = false; // حالة الشريط: هل هو ممتد أم دائرة؟

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        width: isExpanded ? 300 : 60, // العرض يتغير بناءً على الحالة
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.white, // اللون البيج في الصورة
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(30),
            bottomLeft: const Radius.circular(30),
            topRight: Radius.circular(isExpanded ? 30 : 30),
            bottomRight: Radius.circular(isExpanded ? 10 : 30),
          ),
        ),
        child: Row(
          children: [
            // أيقونة البحث داخل الدائرة الداكنة
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: AppColors.honeyYellow, // اللون البني الداكن للأيقونة
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, color: Colors.white),
              ),
            ),
            // حقل النص يظهر فقط عند التمدد
            Expanded(
              child: AnimatedOpacity(
                opacity: isExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: isExpanded
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          autofocus: false,
                          textDirection: TextDirection.rtl, // دعم العربية
                          decoration: InputDecoration(
                            hintText: 'ابحث هنا...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: AppColors.blackColor),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}