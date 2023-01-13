import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/enums.dart';
import 'package:doctors_online/firebase/controllers/notification_fb_controller.dart';
import 'package:doctors_online/firebase/controllers/user_fb_controller.dart';
import 'package:doctors_online/helpers/sent_fire_base_message_from_server.dart';
import 'package:doctors_online/helpers/snackbar.dart';
import 'package:doctors_online/models/consultation_model.dart';
import 'package:doctors_online/models/notifications_model.dart';
import 'package:doctors_online/models/user_model.dart';
import 'package:doctors_online/views/screens/app/appointment/add_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../firebase/controllers/consultation_fb_controller.dart';

class ConsultationActionButton extends StatefulWidget {
  final String text;
  final ConsultationStatus status;
  final ConsultationModel consultationModel;
  final UserModel? patientModel;
  final bool isLoading;

  const ConsultationActionButton({
    Key? key,
    required this.text,
    required this.status,
    required this.consultationModel,
    this.patientModel,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ConsultationActionButton> createState() =>
      _ConsultationActionButtonState();
}

class _ConsultationActionButtonState extends State<ConsultationActionButton>
    with SnackBarHelper {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: isLoading || widget.isLoading
            ? () {}
            : () async {
                if (widget.status == ConsultationStatus.transferred) {
                  await getPharmacies();
                } else if (widget.status == ConsultationStatus.completed) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AppointmentScreen(
                      consultationModel: widget.consultationModel,
                      status: widget.status,
                      patientModel: widget.patientModel!,
                    ),
                  ));
                } else {
                  await changeConsultationStatus();
                }
              },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
                color: consultationStatusColor(widget.status.name),
                borderRadius: BorderRadius.circular(14.r)),
            alignment: Alignment.center,
            child: isLoading || widget.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                : Text(
                    widget.text,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }

  List<UserModel> pharmacies = [];

  Future<void> getPharmacies() async {
    setState(() {
      isLoading = true;
    });
    try {
      var data = await UserFbController()
          .getPharmaciesByCity(widget.patientModel!.cityId ?? 1);

      pharmacies = data;
      if (pharmacies.isNotEmpty) {
        showPharmacies();
      } else {
        showSnackBar(context,
            message:
                'There is no pharmacies with the same city as patient! you can\'t transfe this requestr.',
            error: true);
      }
    } catch (e) {
      isLoading = false;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> changeConsultationStatus() async {
    setState(() {
      isLoading = true;
    });
    await ConsultationsFbController().updateConsultation(
        widget.status, widget.consultationModel.id,
        pharmacyUId: selectedPharmacy != null
            ? selectedPharmacy!.uId
            : widget.consultationModel.pharmacyUId ?? '');

    /// In-App Notification
    await NotificationFbController().create(notificationsModel);

    /// Push Notification
    await SendFireBaseMessageFromServer().sentMessage(
      fcmTokens: fcmTokens,
      title: notificationsModel.title,
      body: notificationsModel.body,
    );
    Navigator.of(context).pop();
  }

  NotificationsModel get notificationsModel {
    NotificationsModel notificationsModel = NotificationsModel();
    notificationsModel.id = DateTime.now().toString();
    notificationsModel.timestamp = Timestamp.now();
    notificationsModel.receiverUId = receiversUId;
    notificationsModel.title = 'تغيير حالة الاستشارة';
    notificationsModel.body = notificationsBody;

    return notificationsModel;
  }

  String get notificationsBody {
    switch (widget.status) {
      case ConsultationStatus.waiting:
      case ConsultationStatus.deleted:
        break;
      case ConsultationStatus.inProgress:
        return 'تم تغيير حالة الاستشارة الى قيد المراجعة';
      case ConsultationStatus.rejected:
        return 'تم رفض طلب الاستشارة الخاص بكم';
      case ConsultationStatus.transferred:
        return 'x-:تم تحويل طلب الاستشارة الى الصيدلية'
            .replaceAll('x', selectedPharmacy?.username ?? '');
      case ConsultationStatus.completed:
        return 'تم اكمال طلب الاستشارة الخاص بكم مع اضافة مواعيد الدواء , نتمنى لكم السلامة';
    }
    return '';
  }

  List<dynamic> get receiversUId {
    switch (widget.status) {
      case ConsultationStatus.waiting:
      case ConsultationStatus.deleted:
        break;
      case ConsultationStatus.rejected:
      case ConsultationStatus.inProgress:
        return [widget.patientModel?.uId ?? ''];
      case ConsultationStatus.transferred:
        return [widget.patientModel?.uId ?? '', selectedPharmacy?.uId ?? ''];
      case ConsultationStatus.completed:
        return [widget.patientModel?.uId ?? '', ''] /*Maybe Doctor*/;
    }
    return [];
  }

  List<String> get fcmTokens {
    switch (widget.status) {
      case ConsultationStatus.waiting:
      case ConsultationStatus.deleted:
        break;
      case ConsultationStatus.rejected:
      case ConsultationStatus.inProgress:
        return [widget.patientModel?.fcmToken ?? ''];
      case ConsultationStatus.transferred:
        return [
          widget.patientModel?.fcmToken ?? '',
          selectedPharmacy?.fcmToken ?? ''
        ];
      case ConsultationStatus.completed:
        return [widget.patientModel?.fcmToken ?? ''] /*Maybe Doctor*/;
    }
    return [];
  }

  UserModel? selectedPharmacy;

  void showPharmacies() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, myState) => ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              itemCount: pharmacies.length,
              itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    myState(() {
                      selectedPharmacy = pharmacies[index];
                    });
                    Navigator.of(context).pop();
                    await changeConsultationStatus();
                  },
                  child: Text(
                    pharmacies[index].username,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500),
                  )),
              separatorBuilder: (context, index) => Divider(
                height: 1.h,
                color: Colors.cyanAccent,
              ),
            ),
          );
        });
  }
}
