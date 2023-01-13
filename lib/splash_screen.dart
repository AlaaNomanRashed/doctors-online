import 'package:doctors_online/enums.dart';
import 'package:doctors_online/firebase/controllers/major_fb_controller.dart';
import 'package:doctors_online/providers/app_provider.dart';
import 'package:doctors_online/shared_preferences/shared_preferences.dart';
import 'package:doctors_online/views/screens/app/home_screen.dart';
import 'package:doctors_online/views/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'firebase/controllers/city_fb_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> navigate() async {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => (SharedPreferencesController()
                    .getter(type: bool, key: SpKeys.loggedIn)) ==
                true
            ? const HomeScreen()
            : const LoginScreen(),
      ));
    });
  }

  Future<void> getCities() async {
    var data = await CityFbController().readCities();
    Provider.of<AppProvider>(context, listen: false).setCities(data);
  }

  Future<void> getMajors() async {
    var data = await MajorFbController().readMajor();

    Provider.of<AppProvider>(context, listen: false).setMajor(data);
  }

  Future<void> init() async {
    await getCities();
    await getMajors();
    await navigate();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/doctors.png'),
              SizedBox(
                height: 30.h,
              ),
              Text(
                'medical consulting',
                style: TextStyle(
                  color: const Color(0xFF134b5f),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Appoint Your Doctor',
                style: TextStyle(
                  color: Color(0xFF134b5f),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              Image.asset('assets/images/heart.png'),
            ],
          ),
        ),
      ),
    );
  }
}
