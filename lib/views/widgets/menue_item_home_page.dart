import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenueItemHomePage extends StatelessWidget {

  final Function() onTap;
  final String image;
  final String title;

  const MenueItemHomePage({
    Key? key, required this.onTap, required this.image, required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: 6.w,
        vertical: 24.h,
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Image.asset(
              image,
              height: 180.h,
              width: 300.w,
             // fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.transparent,
              ),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0b2d39)

                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}