import 'package:doctors_online/enums.dart';
import 'package:doctors_online/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/lang_provider.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../screens/app/consultation/medical_reports.dart';
import '../screens/app/appointment/medications_and_dates.dart';
import '../screens/app/user/setting_screen.dart';
import '../screens/auth/login_screen.dart';
import 'list_tile_item_drawer.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0b2d39),
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
                accountName: Text(
                    SharedPreferencesController()
                        .getter(type: String, key: SpKeys.username),
                    style: TextStyle(color: Colors.black, fontSize: 16.sp)),
                accountEmail: Text(
                    SharedPreferencesController()
                        .getter(type: String, key: SpKeys.email),
                    style: TextStyle(color: Colors.black54, fontSize: 8.sp)),
                currentAccountPictureSize: const Size.square(80),
                currentAccountPicture:
                    Provider.of<AuthProvider>(context, listen: false)
                            .avatar_
                            .isNotEmpty
                        ? CircleAvatar(
                            radius: 55.w,
                            backgroundImage: NetworkImage(
                                Provider.of<AuthProvider>(context).avatar_))
                        : CircleAvatar(
                            radius: 55.w,
                            backgroundImage:
                                const AssetImage('assets/images/avatar.jpg')),
              ),
              ListTileItemDrawer(
                title: AppLocalizations.of(context)!.home,
                icon: Icons.home,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTileItemDrawer(
                title: AppLocalizations.of(context)!.profile,
                icon: Icons.person,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingScreen()));
                },
              ),

              SharedPreferencesController()
                          .getter(type: String, key: SpKeys.userType)
                          .toString() ==
                      'patient'
                  ? ListTileItemDrawer(
                      title: AppLocalizations.of(context)!.myMedicalReports,
                      icon: Icons.medication_outlined,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const MedicalReportsScreen()));
                      },
                    )
                  : const SizedBox.shrink(),
              SharedPreferencesController()
                          .getter(type: String, key: SpKeys.userType)
                          .toString() ==
                      'patient'
                  ? ListTileItemDrawer(
                      title: AppLocalizations.of(context)!.datesMedications,
                      icon: Icons.alarm_add_sharp,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const DatesMedicationsScreen()));
                      },
                    )
                  : const SizedBox.shrink(),
              ListTileItemDrawer(
                title:  Provider.of<LangProviders>(context).lang_ == 'en' ? 'العربية':'Language',
                icon: Icons.language,
                onTap: ()async {
                  await Provider.of<LangProviders>(context, listen: false)
                      .changeLanguage();
                },
              ),
              ListTileItemDrawer(
                title:  AppLocalizations.of(context)!.logout,
                icon: Icons.logout,
                onTap: ()async {
                  await FirebaseAuth.instance.signOut();
                  await FirebaseMessaging.instance.deleteToken();
                  await FirebaseMessaging.instance.unsubscribeFromTopic('updates');
                  await SharedPreferencesController().logout();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
              ),

            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Doctors online',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
