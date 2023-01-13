import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/enums.dart';
import 'package:doctors_online/firebase/controllers/appointment_fb_controller.dart';
import 'package:doctors_online/helpers/snackbar.dart';
import 'package:doctors_online/models/consultation_model.dart';
import 'package:doctors_online/models/custom_models/custom_appointment_model.dart';
import 'package:doctors_online/models/user_model.dart';
import 'package:doctors_online/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../firebase/controllers/consultation_fb_controller.dart';
import '../../../../firebase/controllers/notification_fb_controller.dart';
import '../../../../helpers/sent_fire_base_message_from_server.dart';
import '../../../../models/appointment_model.dart';
import '../../../../models/notifications_model.dart';
import '../../../widgets/my_button.dart';
import '../../../widgets/text_field.dart';

class AppointmentScreen extends StatefulWidget {
  final ConsultationStatus status;
  final ConsultationModel consultationModel;
  final UserModel patientModel;
  const AppointmentScreen(
      {Key? key,
      required this.status,
      required this.consultationModel,
      required this.patientModel})
      : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SnackBarHelper {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    addCustomAppointments();
  }

  void addCustomAppointments() {
    customAppointments.add(CustomAppointmentModel(
        id: DateTime.now().toString(),
        nameEditingController: TextEditingController(),
        noteEditingController: TextEditingController(),
        times: [
          TimeOfDay.now(),
        ]));
  }

  void deleteCustomAppointments(int index) {
    setState(() {
      customAppointments[index].nameEditingController.dispose();
      customAppointments[index].noteEditingController.dispose();
      customAppointments.removeAt(index);
    });
  }

  List<CustomAppointmentModel> customAppointments = [];
  bool isLoading = false;

  @override
  void dispose() {
    for (int i = 0; i < customAppointments.length; i++) {
      deleteCustomAppointments(i);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b2d39),
        title: Text(
          AppLocalizations.of(context)!.addMedicationAppointments,
        ),
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              itemCount: customAppointments.length,
              itemBuilder: (context, index) =>
                  _buildAppointmentContainer(index),
              separatorBuilder: (context, index) => Divider(
                height: 2.h,
                color: Colors.grey,
              ),
            ),
         ///   _buildAddAppointmentCircle
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            addCustomAppointments();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFF0b2d39),
      ),
      bottomNavigationBar: MyButton(
        buttonName: AppLocalizations.of(context)!.add,
        isLoading: isLoading,
        onPressed: () async {
          await performAdd();
        },
      ),
    );
  }

  Future<void> performAdd() async {
    if (checkData) {
      await changeConsultationStatus();
    }
  }

  DateTime dateTime = DateTime.now();
  Future<void> addAppointments() async {
    try {
      /// Convert & Join Appointments
      for (int i = 0; i < customAppointments.length; i++) {
        /// 1- Convert
        AppointmentModel appointmentModel = AppointmentModel();
        appointmentModel.id = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          i,
          i,
        ).toString();
        appointmentModel.name =
            customAppointments[i].nameEditingController.text;
        appointmentModel.note =
            customAppointments[i].noteEditingController.text;
        appointmentModel.times = customAppointments[i]
            .times
            .map((e) => '${e.hour}:${e.minute}')
            .toList();
        appointmentModel.patientUId = widget.patientModel.uId;
        appointmentModel.pharmacyUId = SharedPreferencesController()
            .getter(type: String, key: SpKeys.uId)
            .toString();

        /// 2- Join
        setState(() {
          appointments.add(appointmentModel);
        });
      }

      /// Sent To FireStore
      for (int i = 0; i < appointments.length; i++) {
        await AppointmentsFbController().create(appointments[i]);
      }
    } catch (e) {
      showSnackBar(context, message: e.toString(), error: true);
    }
  }

  List<AppointmentModel> appointments = [];

  bool get checkData {
    if (customAppointments.isEmpty) {
      showSnackBar(context,
          message: 'Add at least one appointment for medication.', error: true);
      return false;
    } else if (customAppointments.isNotEmpty) {
      for (int i = 0; i < customAppointments.length; i++) {
        if (customAppointments[i].nameEditingController.text.isEmpty) {
          showSnackBar(context,
              message: 'Please enter the medication\'s name.', error: true);
          return false;
        } else if (customAppointments[i].times.isEmpty) {
          showSnackBar(context,
              message:
                  'You must enter at least one appointment for each medication',
              error: true);
          return false;
        }
      }
    }

    return true;
  }

  Container _buildAppointmentContainer(int mainIndex) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Colors.black87,
            width: 1.w,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextInputField(
                  hint: AppLocalizations.of(context)!.medicamentName,
                  controller:
                      customAppointments[mainIndex].nameEditingController,
                  icon: Icons.add,
                ),
              ),
              _buildDeleteAppointmentCircle(mainIndex),
            ],
          ),
          SizedBox(
            height: 6.h,
          ),
          TextInputField(
            hint: AppLocalizations.of(context)!.note,
            controller: customAppointments[mainIndex].noteEditingController,
            icon: Icons.add,
          ),
          SizedBox(
            height: 6.h,
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, subIndex) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${AppLocalizations.of(context)!.theAppointment.replaceAll('x', '${subIndex + 1}')} :-'),
                InkWell(
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime:
                            customAppointments[mainIndex].times[subIndex],
                      );
                      if (newTime == null) return;
                      setState(() {
                        customAppointments[mainIndex].times[subIndex] = newTime;
                      });
                    },
                    child: Text(
                        '${customAppointments[mainIndex].times[subIndex].hour}:${customAppointments[mainIndex].times[subIndex].minute}')),
                _buildRemoveTimeCircle(mainIndex, subIndex),
              ],
            ),
            separatorBuilder: (context, index) => SizedBox(
              height: 4.h,
            ),
            itemCount: customAppointments[mainIndex].times.length,
          ),
          _buildAddTimeCircle(mainIndex),
        ],
      ),
    );
  }

  Widget _buildAddTimeCircle(int mainIndex) {
    return InkWell(
      onTap: () async {
        setState(() {
          customAppointments[mainIndex].times.add(TimeOfDay.now());
        });
      },
      child: Row(
        children: [
          Image.asset(
            'assets/images/add.png',
            width: 45.w,
            height: 45.h,
          ),
          Text(
            AppLocalizations.of(context)!.addAppointment,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveTimeCircle(int mainIndex, int subIndex) {
    return InkWell(
        onTap: () async {
          setState(() {
            customAppointments[mainIndex].times.removeAt(subIndex);
          });
        },
        child: const Icon(Icons.remove_circle));
  }

  // Widget get _buildAddAppointmentCircle {
  //   return Center(
  //     child: InkWell(
  //       onTap: () {
  //         setState(() {
  //           addCustomAppointments();
  //         });
  //       },
  //       child: Container(
  //         width: 50.w,
  //         height: 50.h,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           border: Border.all(
  //             color: Colors.black87,
  //             width: 1.w,
  //           ),
  //         ),
  //         child: const Icon(Icons.add),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDeleteAppointmentCircle(int index) {
    return Center(
      child: InkWell(
        onTap: () {
          setState(() {
            deleteCustomAppointments(index);
          });
        },
        child: Image.asset(
          'assets/images/delete.png',
          width: 60.w,
          height: 60.h,
        ),
      ),
    );
  }

  Future<void> changeConsultationStatus() async {
    setState(() {
      isLoading = true;
    });
    await addAppointments();
    await ConsultationsFbController().updateConsultation(
        widget.status, widget.consultationModel.id,
        pharmacyUId: widget.consultationModel.pharmacyUId ?? '');

    /// In-App Notification
    await NotificationFbController().create(notificationsModel);

    /// Push Notification
    await SendFireBaseMessageFromServer().sentMessage(
      fcmTokens: [widget.patientModel.fcmToken ?? ''],
      title: notificationsModel.title,
      body: notificationsModel.body,
    );
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  NotificationsModel get notificationsModel {
    NotificationsModel notificationsModel = NotificationsModel();
    notificationsModel.id = DateTime.now().toString();
    notificationsModel.timestamp = Timestamp.now();
    notificationsModel.receiverUId = [widget.patientModel.uId];
    notificationsModel.title = 'تغيير حالة الاستشارة';
    notificationsModel.body =
        'تم اكمال طلب الاستشارة الخاص بكم مع اضافة مواعيد الدواء , نتمنى لكم السلامة';

    return notificationsModel;
  }
}
