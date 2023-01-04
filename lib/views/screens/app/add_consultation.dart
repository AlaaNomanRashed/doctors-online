import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:doctors_online/helpers/snackbar.dart';
import 'package:doctors_online/models/consultation_model.dart';
import 'package:doctors_online/models/user_model.dart';
import 'package:doctors_online/providers/app_provider.dart';
import 'package:doctors_online/shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../firebase/controllers/consultation_fb_controller.dart';
import '../../../firebase/controllers/fb_storage_controller.dart';
import '../../../firebase/controllers/user_fb_controller.dart';
import '../../../models/major_model.dart';
import '../../widgets/my_button.dart';
import '../../widgets/no_data.dart';
import '../../widgets/text_field.dart';

class AddConsultationScreen extends StatefulWidget {
  const AddConsultationScreen({Key? key}) : super(key: key);

  @override
  State<AddConsultationScreen> createState() => _AddConsultationScreenState();
}

class _AddConsultationScreenState extends State<AddConsultationScreen>
    with SnackBarHelper {
  late TextEditingController noteEditingController;
  bool isLoading = false;
  @override
  void initState() {
    noteEditingController = TextEditingController();
    myStream = UserFbController().readUser();
    super.initState();
  }

  @override
  void dispose() {
    noteEditingController.dispose();
    super.dispose();
  }
var myStream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFa8d5e5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0b2d39),
          title: const Text('Medical Consultation'),
          centerTitle: true,
        ),
        body: /* doctors != null ? */
            Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInputField(
                  controller: noteEditingController,
                  hint: 'add note here',
                  icon: Icons.note_add_sharp,
                  inputType: TextInputType.text,
                  height: 120.h,
                ),

                /// major
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      showMajors();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[500]!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.subject,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Error => No Element',

                              /// todo selectedMajor.majorEn??''
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// doctor
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      showDoctors();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[500]!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.heart_broken_outlined,
                                color: Colors.white,
                              ),
                            ),
                            selectedDoctor != null
                                ? Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey.shade100,
                                        backgroundImage: NetworkImage(
                                            selectedDoctor!.avatar ?? ''),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        /// todo error => null
                                        selectedDoctor!.username ?? '',
                                        style: TextStyle(
                                            color: Colors.indigo[900]),
                                      ),
                                    ],
                                  )
                                : const Text('Doctors'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort medical reports :-',
                      style: TextStyle(
                        color: const Color(0xFF0b2d39),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () async {
                        await addNewImage();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.upload_file_sharp),
                          Text('add'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.h,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: myStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    } else if (snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty) {
                      UserModel userModel = UserModel.fromMap(
                          snapshot.data!.docs.first.data()
                              as Map<String, dynamic>);
                      if (userModel.medicalReports.isNotEmpty) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8.h,
                            crossAxisSpacing: 8.w,
                          ),
                          shrinkWrap: true,
                          itemCount: userModel.medicalReports.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onLongPress: () {
                              setState(() {
                                int found = selectedMedicalReports.indexWhere(
                                    (element) =>
                                        element ==
                                        userModel.medicalReports![index]);
                                if (found == -1) {
                                  selectedMedicalReports
                                      .add(userModel.medicalReports![index]);
                                }
                              });
                            },
                            onTap: () {
                              setState(() {
                                selectedMedicalReports.removeWhere((element) =>
                                    element ==
                                    userModel.medicalReports![index]);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border:selectedMedicalReports.contains(userModel.medicalReports![index]) ?Border.all(
                                color: Colors.black,
                                width: 3,
                              ):null,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: userModel.medicalReports[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const NoData();
                      }
                    } else {
                      return const NoData();
                    }
                  },
                )
              ],
            ),
          ),
        ),
        /*  : const Center(child: CircularProgressIndicator(color: Color(0xFF0b2d39),)),*/

        bottomNavigationBar: /* doctors != null ?*/ Padding(
          padding: const EdgeInsets.all(16.0),
          child: MyButton(
            buttonName: 'Add Medical Consultation ',
            isLoading: isLoading,
            onPressed: () async {
              await performAddConsultation();
            },
          ),
        ) /*:const SizedBox.shrink(),*/
        );
  }

  late List<MajorModel> majors =
      Provider.of<AppProvider>(context, listen: false).majors_;

  late MajorModel selectedMajor =
      Provider.of<AppProvider>(context, listen: false).majors_.first;

  List<UserModel>? doctors;
  UserModel? selectedDoctor;

  Future<void> getDoctors() async {
    try {
      /// UserFbController  getUsersByType(doctor)
      var data =
          await UserFbController().getUsersByType(types: UserTypes.doctor);
      doctors = data ?? [];
      selectedDoctor = doctors!.first;
    } catch (e) {
      doctors = [];
    }
  }

  List<UserModel> get majorDoctors {
    List<UserModel> list = [];
    for (int i = 0; i < doctors!.length; i++) {
      if (doctors![i].majorId == selectedMajor.id) {
        int found =
            list.indexWhere((element) => element.uId == doctors![i].uId);
        if (found == -1) {
          list.add(doctors![i]);
        }
      }
    }
    return list;
  }

  List<String> selectedMedicalReports = [];

  void showMajors() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, hereState) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    hereState(() {
                      selectedMajor = majors[index];
                      selectedDoctor = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    majors[index].majorEn ?? '',
                    style: TextStyle(color: Colors.indigo[900]),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.blueGrey,
                  height: 22.h,
                );
              },
              itemCount: majors.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            );
          });
        });
  }

  void showDoctors() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, hereState) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    hereState(() {
                      selectedDoctor = majorDoctors[index];
                    });
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        backgroundImage:
                            NetworkImage(majorDoctors[index].avatar ?? ''),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        /// todo error => null
                        majorDoctors[index].username ?? '',
                        style: TextStyle(color: Colors.indigo[900]),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.blueGrey,
                  height: 22.h,
                );
              },
              itemCount: majorDoctors.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            );
          });
        });
  }

  Future<void> performAddConsultation() async {
    if (checkData) {
      await addConsultation();
    }
  }

  Future<void> addConsultation() async {
    setState(() {
      isLoading = true;
    });
    try {
      await ConsultationsFbController().create(consultation);
    /// todo: send notification to doctor
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  ConsultationModel get consultation {
    ConsultationModel consultationModel = ConsultationModel();

    consultationModel.id = DateTime.now().toString();
    consultationModel.patientUId = SharedPreferencesController()
        .getter(type: String, key: SpKeys.uId)
        .toString();
    consultationModel.majorId = selectedMajor.id;
    consultationModel.doctorUId = selectedDoctor!.uId;
    consultationModel.note = noteEditingController.text;
    consultationModel.medicalReports = selectedMedicalReports;
    consultationModel.timestamp = Timestamp.now();
    consultationModel.requestStatus = ConsultationStatus.waiting.name ;

    return consultationModel;
  }

  bool get checkData {
    if (noteEditingController.text.isEmpty) {
      showSnackBar(context,
          message: 'Add notes to help the doctor diagnose your condition',
          error: true);
      return false;
    } else if (selectedDoctor == null) {
      showSnackBar(context,
          message:
              'Which doctor would you like to follow up on your health? Please.. choose it first!',
          error: true);
      return false;
    }else if(selectedMedicalReports.isEmpty){
      showSnackBar(context, message: 'Please. Choose at least one file so that your doctor can diagnose your health condition', error: true);
    }
    return true;
  }

  List<XFile> newImages = [];

  Future<void> addNewImage() async {
    setState(() {
      newImages.clear();
      isLoading = true;
    });
    await pickImage();
    for (int i = 0; i < newImages.length; i++) {
      await uploadImages(newImages[i].path);
    }
    setState(() {
      isLoading = false;
    });
  }

  var imagePicker = ImagePicker();
  Future<void> pickImage() async {
    var pickImage = await imagePicker.pickMultiImage(imageQuality: 50);
    setState(() {
      newImages = pickImage;
    });
  }

  Future<void> uploadImages(String path) async {
    await FbStorageController().uploadMedicalReports(
        file: File(path),
        context: context,
        callBackUrl: ({
          required String url,
          required bool status,
          required TaskState taskState,
        }) async {
          if (taskState == TaskState.success) {
            await UserFbController().addNewFile(url);
            showSnackBar(context,
                message: 'The image has been added successfully', error: false);
          } else {
            showSnackBar(context,
                message: 'Adding the image failed', error: true);
          }
        });
  }
}
