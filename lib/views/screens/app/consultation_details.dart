import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_online/enums.dart';
import 'package:doctors_online/firebase/controllers/user_fb_controller.dart';
import 'package:doctors_online/models/consultation_model.dart';
import 'package:doctors_online/providers/app_provider.dart';
import 'package:doctors_online/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../firebase/controllers/consultation_fb_controller.dart';
import '../../../models/major_model.dart';
import '../../../models/user_model.dart';
import '../../widgets/consultation_action_icon.dart';

class ConsultationDetails extends StatefulWidget {
  final ConsultationModel consultationModel;
  const ConsultationDetails({Key? key, required this.consultationModel})
      : super(key: key);

  @override
  State<ConsultationDetails> createState() => _ConsultationDetailsState();
}

class _ConsultationDetailsState extends State<ConsultationDetails> {
  @override
  void initState() {
    getData();
    super.initState();
  }
  bool actionLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b2d39),
        title: const Text('Consultation Details'),
        centerTitle: true,
        actions: [action],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
                Chip(
                  label: Text(consultationStatusText(context ,widget.consultationModel.requestStatus!  )),
                  backgroundColor: consultationStatusColor(consultationStatus.name).withOpacity(0.7),
                  padding: EdgeInsets.zero,
                  labelStyle: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Divider(
              height: 5.h,
            ),
            SizedBox(
              height: 16.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDoctor!.username,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  SharedPreferencesController()
                              .getter(type: String, key: SpKeys.lang)
                              .toString() ==
                          'ar'
                      ? selectedMajor.majorAr ?? ''
                      : selectedMajor.majorEn ?? '',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Divider(
              height: 5.h,
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              widget.consultationModel.note ?? '',
              style: TextStyle(
                  fontSize: 14.sp, fontWeight: FontWeight.bold, height: 1.h),
            ),
            SizedBox(
              height: 16.h,
            ),
            widget.consultationModel.medicalReports!.isNotEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                    ),
                    itemCount: widget.consultationModel.medicalReports!.length,
                    itemBuilder: (context, index) => Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              widget.consultationModel.medicalReports![index],
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Future<void> changeConsultationStatus(
      ConsultationStatus consultationStatus) async {
    setState(() {
      actionLoading = true;
    });
    await ConsultationsFbController().changeConsultationStatus(
        consultationStatus, widget.consultationModel.id);
    Navigator.of(context).pop();

    /// TODO : send Notification for user Type
  }

  Widget get action {
    UserTypes userTypes = UserTypes.values.firstWhere((element) =>
        element.name ==
        SharedPreferencesController()
            .getter(type: String, key: SpKeys.userType)
            .toString());
    switch (userTypes) {
      case UserTypes.doctor:
        // TODO: Handle this case.
        break;
      case UserTypes.patient:
        return consultationStatus == ConsultationStatus.waiting
            ? ConsultationActionIcon(
                text: 'Delete',
                icon: Icons.minimize,
                status: ConsultationStatus.deleted,
                isLoading:actionLoading ,
                onTap: ()async {
                  await changeConsultationStatus(ConsultationStatus.deleted,);
                },
              )
            : const SizedBox.shrink();
      case UserTypes.pharmacy:
        // TODO: Handle this case.
        break;
    }

    return const SizedBox.shrink();
  }

  late ConsultationStatus consultationStatus = ConsultationStatus.values
      .firstWhere(
          (element) => element.name == widget.consultationModel.requestStatus!);

  String get date {
    return '${widget.consultationModel.timestamp.toDate().year}/${widget.consultationModel.timestamp.toDate().month}/${widget.consultationModel.timestamp.toDate().day}';
  }


  Future<void> getData() async {
    await getDoctor();
  }

  late MajorModel selectedMajor = Provider.of<AppProvider>(context)
      .majors_
      .firstWhere((element) => element.id == widget.consultationModel.majorId);

  UserModel? selectedDoctor;

  Future<void> getDoctor() async {
    var doctor = await UserFbController()
        .getOneUser(widget.consultationModel.doctorUId!);

    setState(() {
      selectedDoctor = doctor;
    });
  }
}
