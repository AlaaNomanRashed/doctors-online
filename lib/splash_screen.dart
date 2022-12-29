import 'package:doctors_online/views/screens/app/home_screen.dart';
import 'package:doctors_online/views/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> init() async {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context)=>const LoginScreen(),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: const Color(0xFFa8d5e5),
      body: SafeArea(
        child: Column(
          children: [
Image.asset('assets/images/doctors.png'),
            SizedBox(height: 60.h,),
            Text(
                'medical consulting',
              style: TextStyle(
                color: Color(0xFF134b5f),
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 14.h,),
            Text(
              'Appoint Your Doctor',
              style: TextStyle(
                color: Color(0xFF134b5f),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 60.h,),
            Image.asset('assets/images/heart.png'),
          ],
        ),
      ),
    );
  }
}
