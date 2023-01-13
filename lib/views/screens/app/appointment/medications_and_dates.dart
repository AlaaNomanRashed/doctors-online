import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/enums.dart';
import 'package:doctors_online/models/appointment_model.dart';

import 'package:doctors_online/views/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../firebase/controllers/appointment_fb_controller.dart';
import '../../../widgets/appointment_item.dart';
import '../../../widgets/text_field.dart';
import '../consultation/add_consultation.dart';

class DatesMedicationsScreen extends StatefulWidget {
  const DatesMedicationsScreen({Key? key}) : super(key: key);

  @override
  State<DatesMedicationsScreen> createState() =>
      _DatesMedicationsScreenState();
}

class _DatesMedicationsScreenState
    extends State<DatesMedicationsScreen> {


  late TextEditingController searchEditingController;
  List<AppointmentModel> searchAppointment = [];
  List<QueryDocumentSnapshot<AppointmentModel>> appointments = [];

  @override
  void initState() {
    searchEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b2d39),
        title:const Text('Dates Medications'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddConsultationScreen()));
              },
              child: Row(
                children: const [
                  Icon(Icons.upload_file_sharp),
                  Text('add'),
                ],
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20.h,
          right: 6.w,
          left: 6.w,
        ),
        child: Column(
          children: [
            TextInputField(
              controller: searchEditingController,
              hint: 'Search',
              onChanged: (searchValue) {
                setState(() {
                  for (int i = 0; i < appointments.length; i++) {
                    searchAppointment.clear();
                    if (appointments[i]
                        .data()
                        .name!
                        .toLowerCase()
                        .contains(searchValue.toLowerCase())) {
                      searchAppointment.add(appointments[i].data());
                    }
                  }
                });
              },
              icon: Icons.search_rounded,
              inputType: TextInputType.text,
            ),
            SizedBox(
              height: 18.h,
            ),
            Expanded(
              child: searchEditingController.text.isEmpty &&
                  searchAppointment.isEmpty
                  ? StreamBuilder<QuerySnapshot<AppointmentModel>>(
                stream:AppointmentsFbController().readPatientAppointments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0b2d39),
                      ),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    appointments = snapshot.data!.docs;
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        return AppointmentItem(appointmentModel : appointments[index].data());
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 20.h,
                        );
                      },
                    );
                  } else {
                    return const NoData();
                  }
                },
              )
                  : searchAppointment.isNotEmpty
                  ? ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: searchAppointment.length,
                itemBuilder: (context, index) {
                  return AppointmentItem(appointmentModel: searchAppointment[index],);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 20.h,
                  );
                },
              )
                  : const NoData(),
            ),
          ],
        ),
      ),
    );
  }
}


