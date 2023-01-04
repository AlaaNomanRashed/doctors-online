import 'package:doctors_online/models/user_model.dart';
import 'package:doctors_online/views/screens/app/medical_reports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared_preferences/shared_preferences.dart';
import '../../widgets/my_button.dart';
import '../auth/login_screen.dart';
import 'modify_profile.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  final credential = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  File? file_;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await FirebaseMessaging.instance.deleteToken();
              await SharedPreferencesController().logout();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            label: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: const Color(0xFF0b2d39),
        title: const Text('Personal Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white54,
                    radius: 60.w,
                    backgroundImage: NetworkImage(userModel!.avatar),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                "Email: ${credential!.email} ",
                style: TextStyle(
                  fontSize: 17.sp,
                ),
              ),
              SizedBox(
                height: 11.h,
              ),
              Text(
                "Created date:  ${credential!.metadata.creationTime}   ",
                style: TextStyle(
                  fontSize: 17.sp,
                ),
              ),
              SizedBox(
                height: 11.h,
              ),
              Text(
                "Last Signed In: ${credential!.metadata.lastSignInTime}    ",
                style: TextStyle(
                  fontSize: 17.sp,
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              MyButton(
                buttonName: 'Modify profile',
                isLoading: isLoading,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ModifyProfileScreen()));
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              MyButton(
                buttonName: 'My Medical Reports',
                isLoading: isLoading,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MedicalReportsScreen()));
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              MyButton(
                buttonName: 'Change language',
                isLoading: isLoading,
                onPressed: () {
                  /// lang
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
