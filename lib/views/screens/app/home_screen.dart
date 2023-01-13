import 'package:doctors_online/firebase/fb_notifications.dart';
import 'package:doctors_online/views/screens/app/user/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../enums.dart';
import '../../../shared_preferences/shared_preferences.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/menue_item_home_page.dart';
import 'appointment/medications_and_dates.dart';
import 'consultation/consultation_requests.dart';
import 'consultation/medical_reports.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with FbNotifications {
  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    initializeForegroundNotificationForAndroid();
    manageNotificationAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b2d39),
        title: Text(AppLocalizations.of(context)!.dwaee),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NotificationsScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_active_outlined,
                      color: Color(0xFF0b2d39),
                      size: 38,
                    ),
                    SizedBox(width: 6.w,),
                    Text(
                      AppLocalizations.of(context)!.notifications,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0b2d39),
                      ),
                    ),

                  ],
                ),
              ),
              Divider(color: Colors.blueGrey,height: 3.h,),

              SharedPreferencesController()
                          .getter(type: String, key: SpKeys.userType)
                          .toString() ==
                      'patient'
                  ? MenueItemHomePage(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const MedicalReportsScreen()));
                      },
                      image: 'assets/images/report.png',
                      title:
                          AppLocalizations.of(context)!.myMedicalReports,
                    )
                  : const SizedBox.shrink(),

              MenueItemHomePage(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                      const ConsultationRequestsScreen()));
                },
                image: 'assets/images/consulting.png',
                title: AppLocalizations.of(context)!.consulting,
              ),
              SharedPreferencesController()
                          .getter(type: String, key: SpKeys.userType)
                          .toString() ==
                      'patient'
                  ? MenueItemHomePage(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const DatesMedicationsScreen()));
                      },
                      image: 'assets/images/alarm.png',
                      title:
                          AppLocalizations.of(context)!.datesMedications,
                    )
                  : const SizedBox.shrink(),
              MenueItemHomePage(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingScreen()));
                },
                image: 'assets/images/setting.png',
                title: AppLocalizations.of(context)!.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
