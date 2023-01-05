import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_drawer.dart';
import 'consultation_requests.dart';
import 'medical_reports.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b2d39),
        title: const Text('Home'),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ConsultationRequestsScreen()));
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                            //  color:const Color(0xFF0b2d39),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            width: 140.w,
                            height: 140.h,
                            child: Image.asset('assets/images/medicalConsultation.png'),
                          ),
                          SizedBox(height: 6.h,),
                          Text(
                              AppLocalizations.of(context)!.consulting,
                            style: TextStyle( 
                              color: const Color(0xFF0b2d39),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MedicalReportsScreen()));
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                            //  color: const Color(0xFF0b2d39),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            width: 140.w,
                            height: 140.h,
                            child: Image.asset('assets/images/medicalReport.png'),
                          ),
                          SizedBox(height: 6.h,),
                          Text(
                            'Medical Reports',
                            style: TextStyle(
                                color: const Color(0xFF0b2d39),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}


