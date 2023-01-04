import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/lang_provider.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../screens/app/medical_reports.dart';
import '../screens/app/profile_screen.dart';
import '../screens/auth/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:  const Color(0xFF0b2d39),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover),
                ),
                accountName: Text(SharedPreferencesController().getter(type: String, key: SpKeys.username),
                    style:  TextStyle(
                        color: Colors.black,
                        fontSize: 40.sp
                    )),
                accountEmail: Text(SharedPreferencesController().getter(type: String, key: SpKeys.email)),
                currentAccountPictureSize: const Size.square(99),
                currentAccountPicture: CircleAvatar(
                  radius: 55.w,
                  backgroundImage:
                  const AssetImage('assets/images/doctor1.jpg'),
                ),
              ),
              ListTile(
                  title:  Text('Home',style: TextStyle(color: Colors.white,fontSize: 16.sp),),
                  leading: const Icon(Icons.home,color: Colors.white, size: 30,),
                  onTap: ()  {
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  title:  Text('Profile',style: TextStyle(color: Colors.white,fontSize: 16.sp),),
                  leading: const Icon(Icons.person,color: Colors.white, size: 30,),
                  onTap: ()  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ProfileScreen()));
                  }),
              ListTile(
                  title:  Text('My Medical Reports',style: TextStyle(color: Colors.white,fontSize: 16.sp),),
                  leading: const Icon(Icons.medication_sharp,color: Colors.white, size: 30,),
                  onTap: ()  {
                    Navigator.of(context).push( MaterialPageRoute(builder: (context)=>const MedicalReportsScreen()));
                  }),
              ListTile(
                  title:  Text('Language',style: TextStyle(color: Colors.white,fontSize: 16.sp),),
                  leading: const Icon(Icons.language,color: Colors.white, size: 30,),
                  onTap: () async {
                    await Provider.of<LangProviders>(context, listen: false)
                        .changeLanguage();
                  }),
              ListTile(
                  title:  Text('Log Out',style: TextStyle(color: Colors.white,fontSize: 16.sp),),
                  leading: const Icon(Icons.exit_to_app,color: Colors.white, size: 30,),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    await FirebaseMessaging.instance.deleteToken();
                    await SharedPreferencesController().logout();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  }),
            ],
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Doctors online',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color:  Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}