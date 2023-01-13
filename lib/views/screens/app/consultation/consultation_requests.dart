import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/enums.dart';
import 'package:doctors_online/firebase/controllers/consultation_fb_controller.dart';
import 'package:doctors_online/models/consultation_model.dart';
import 'package:doctors_online/shared_preferences/shared_preferences.dart';
import 'package:doctors_online/views/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/consultation_item.dart';
import '../../../widgets/text_field.dart';
import 'add_consultation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///  طلبات الاستشارة
class ConsultationRequestsScreen extends StatefulWidget {
  const ConsultationRequestsScreen({Key? key}) : super(key: key);

  @override
  State<ConsultationRequestsScreen> createState() =>
      _ConsultationRequestsScreenState();
}

class _ConsultationRequestsScreenState
    extends State<ConsultationRequestsScreen> {
  late TextEditingController searchEditingController;
  List<ConsultationModel> searchConsultation = [];
  List<QueryDocumentSnapshot<ConsultationModel>> consultations = [];

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
        title: SharedPreferencesController()
                    .getter(type: String, key: SpKeys.userType) ==
                'pharmacy'
            ? Text(AppLocalizations.of(context)!.transferRequests)
            : Text(AppLocalizations.of(context)!.consultationRequests),
        centerTitle: true,
        // actions: [
        //   SharedPreferencesController()
        //               .getter(type: String, key: SpKeys.userType)
        //               .toString() ==
        //           'patient'
        //       ? Padding(
        //           padding: const EdgeInsets.all(14.0),
        //           child: InkWell(
        //             onTap: () {
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (context) => const AddConsultationScreen()));
        //             },
        //             child: Row(
        //               children: [
        //                 const Icon(Icons.upload_file_sharp),
        //                 Text(AppLocalizations.of(context)!.add),
        //               ],
        //             ),
        //           ),
        //         )
        //       : const SizedBox.shrink()
        // ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20.h,
          right: 16.w,
          left: 16.w,
        ),
        child: Column(
          children: [
            TextInputField(
              controller: searchEditingController,
              hint: AppLocalizations.of(context)!.search,
              onChanged: (searchValue) {
                setState(() {
                  for (int i = 0; i < consultations.length; i++) {
                    searchConsultation.clear();
                    if (consultations[i]
                        .data()
                        .note!
                        .toLowerCase()
                        .contains(searchValue.toLowerCase())) {
                      searchConsultation.add(consultations[i].data());
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
                      searchConsultation.isEmpty
                  ? StreamBuilder<QuerySnapshot<ConsultationModel>>(
                      stream: SharedPreferencesController()
                                  .getter(type: String, key: SpKeys.userType)
                                  .toString() ==
                              'doctor'
                          ? ConsultationsFbController()
                              .readDoctorConsultations()
                          : SharedPreferencesController()
                                      .getter(
                                          type: String, key: SpKeys.userType)
                                      .toString() ==
                                  'patient'
                              ? ConsultationsFbController()
                                  .readPatientConsultations()
                              : ConsultationsFbController()
                                  .readPharmacyConsultations(),
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
                          consultations = snapshot.data!.docs;
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: consultations.length,
                            itemBuilder: (context, index) {
                              return ConsultationsItem(
                                consultationModel: consultations[index].data(),
                              );
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
                  : searchConsultation.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: searchConsultation.length,
                          itemBuilder: (context, index) {
                            return ConsultationsItem(
                              consultationModel: searchConsultation[index],
                            );
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
      floatingActionButton: SharedPreferencesController()
                  .getter(type: String, key: SpKeys.userType)
                  .toString() ==
              'patient'
          ? Padding(
              padding: const EdgeInsets.all(14.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddConsultationScreen()));
                },
                child: Expanded(
                  child: Container(
                    height: 66.h,
                    width: 66.w,
                    decoration: const BoxDecoration(
                        color: Color(0xFF0b2d39), shape: BoxShape.circle),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         const Icon(Icons.upload_file_outlined, color: Colors.white,size: 33,),
                          // Text(AppLocalizations.of(context)!.add,
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
