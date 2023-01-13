import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:doctors_online/helpers/snackbar.dart';
import 'package:doctors_online/models/appointment_model.dart';
import 'package:doctors_online/views/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AppointmentDetails extends StatefulWidget {
  final AppointmentModel appointment;

  const AppointmentDetails({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails>
    with SnackBarHelper {
  bool isLoading = false;

  @pragma('vm:entry-point')
  static void fireAlarm() async {
    final int isolateId = Isolate.current.hashCode;
    AndroidNotificationChannel channel =
        const AndroidNotificationChannel('app_notification_channel', '');
    try {
      await FlutterLocalNotificationsPlugin().show(
          isolateId,
          'Dawaee',
          'Medicament Reminder',
          NotificationDetails(
              android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'app',
          )));
    } catch (e) {
      ///
    }
  }

  DateTime nowTime = DateTime.now();

  Future<void> setAlarm(String time, bool all) async {
    /// Convert String to Time
    var formattedTime = DateFormat('HH:mm').parse(time);

    /// Alarm
    var status = await AndroidAlarmManager.oneShotAt(
      DateTime(
        nowTime.year,
        nowTime.month,
        nowTime.day,
        formattedTime.hour,
        formattedTime.minute,
      ),

      /// const Duration(days: 1),
      '${formattedTime}__${widget.appointment.id}'.hashCode,
      fireAlarm,
      /*
      startAt: DateTime(
        nowTime.year,
        nowTime.month,
        nowTime.day,
        formattedTime.hour,
        formattedTime.minute,
      ),
      */
      wakeup: true,
      rescheduleOnReboot: false,
    );

    if (!all) {
      showSnackBar(
        context,
        message: status
            ? AppLocalizations.of(context)!.alarmsSetSuccessfully
            : AppLocalizations.of(context)!.alarmsSetFailed,
        error: !status,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b2d39),
        title: Text(widget.appointment.name ?? ''),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.note,
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              widget.appointment.note!.isEmpty
                  ? AppLocalizations.of(context)!.noNote
                  : widget.appointment.note!,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
            ),
            Divider(
              height: 32.h,
              color: Colors.black54,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: widget.appointment.times.length,
              itemBuilder: (context, index) => _buildAppointment(index),
              separatorBuilder: (context, index) => Divider(
                height: 10.h,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyButton(
        onPressed: () async {
          try {
            setState(() {
              isLoading = true;
            });
            for (int i = 0; i < widget.appointment.times.length; i++) {
              await setAlarm(widget.appointment.times[i].toString(), true);
            }
            showSnackBar(context,
                message: AppLocalizations.of(context)!.setAlarmsForAll,
                error: false);
            setState(() {
              isLoading = false;
            });
          } catch (e) {
            showSnackBar(context, message: e.toString(), error: true);
            isLoading = false;
          }
          setState(() {
            isLoading = false;
          });
        },
        isLoading: isLoading,
        buttonName: 'Activate the alarm for all appointments',
      ),
    );
  }

  Widget _buildAppointment(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${AppLocalizations.of(context)!.theAppointment.replaceAll('x', '${index + 1}')}:- ',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          widget.appointment.times[index],
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
            onPressed: () async {
              await setAlarm(widget.appointment.times[index].toString(), false);
            },
            icon: const Icon(Icons.alarm_add_sharp))
      ],
    );
  }
}
