import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/firebase/controllers/fb_storage_controller.dart';
import 'package:doctors_online/firebase/controllers/user_fb_controller.dart';
import 'package:doctors_online/helpers/snackbar.dart';
import 'package:doctors_online/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../widgets/my_button.dart';
import '../../../widgets/no_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class MedicalReportsScreen extends StatefulWidget {
  const MedicalReportsScreen({Key? key}) : super(key: key);

  @override
  State<MedicalReportsScreen> createState() => _MedicalReportsScreenState();
}

class _MedicalReportsScreenState extends State<MedicalReportsScreen>
    with SnackBarHelper {
  CollectionReference bancksCollectionReference =
      FirebaseFirestore.instance.collection('users');
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b2d39),
        title:  Text(AppLocalizations.of(context)!.myMedicalReports),
        centerTitle: true,
      ),

      body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: 20.w,
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: UserFbController().readUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                UserModel userModel = UserModel.fromMap(
                    snapshot.data!.docs.first.data() as Map<String, dynamic>);
                if (userModel.medicalReports.isNotEmpty) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                    ),
                    itemCount: userModel.medicalReports.length,
                    itemBuilder: (context, index) => Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: userModel.medicalReports[index],
                          fit: BoxFit.cover,
                        ),
                        PositionedDirectional(
                            top: 0,
                            end: 0,
                            child: IconButton(
                              onPressed: () async{
                                await deleteFile(userModel.medicalReports[index]);
                              },
                              icon: CircleAvatar(
                                radius: 20.w,
                                backgroundColor: Colors.white,
                                child: const Icon(
                                  Icons.restore_from_trash,
                                  color: Colors.red,
                                ),
                              ),
                            ))
                      ],
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
      ),
     bottomNavigationBar:  Padding(
       padding: const EdgeInsets.all(16.0),
       child: MyButton(
         buttonName: AppLocalizations.of(context)!.addMedicalReports,
         isLoading: isLoading,
         onPressed: ()async{
           await addNewImage();
         },
       ),
     ),
    );
  }

  List<XFile> newImages=[];

  Future<void> addNewImage()async{
    setState(() {
      newImages.clear();
      isLoading = true;
    });
    await pickImage();
    for(int i=0; i< newImages.length; i++){
      await uploadImages(newImages[i].path);
    }
    setState(() {
      isLoading = false;
    });
  }
  var imagePicker = ImagePicker();
  Future<void>pickImage()async{
   var pickImage = await imagePicker.pickMultiImage(imageQuality: 50);
   setState(() {
     newImages = pickImage;
   });
  }
  Future<void> uploadImages(String path)async{
await FbStorageController().uploadMedicalReports(
    file: File(path),
    context: context,
    callBackUrl: ({
      required String url,
      required bool status,
      required TaskState taskState,
    })async{
      if(taskState == TaskState.success){
        await UserFbController().addNewFile(url);
        showSnackBar(context, message: AppLocalizations.of(context)!.theImageHasBeenAddedSuccessfully, error: false);
      }else{
        showSnackBar(context, message: AppLocalizations.of(context)!.addingTheImageFailed, error: true);
      }
    }
);
  }

  Future<void> deleteFile(String image)async{
    await UserFbController().deleteFile(image);
  }











}
