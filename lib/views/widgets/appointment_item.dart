import 'package:doctors_online/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/app/appointment/appointment_detailes.dart';
class AppointmentItem extends StatelessWidget {
  final AppointmentModel appointmentModel;

  const AppointmentItem({Key? key, required this.appointmentModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AppointmentDetails(appointment: appointmentModel,)));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w , vertical: 8.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(width: 1.w, color: Colors.black)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
             appointmentModel.name ??'',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.h),
            ),
            SizedBox(height: 12.h,),
            Text(
              ' ${AppLocalizations.of(context)!.appointmentCount }:- ${appointmentModel.times.length}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
                height: 1.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
