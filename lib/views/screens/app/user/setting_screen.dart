import 'dart:math';
import 'package:doctors_online/providers/lang_provider.dart';
import 'package:path/path.dart' show basename;
import 'package:doctors_online/helpers/snackbar.dart';
import 'package:doctors_online/models/user_model.dart';
import 'package:doctors_online/providers/auth_provider.dart';
import 'package:doctors_online/views/screens/app/consultation/medical_reports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../enums.dart';
import '../../../../firebase/controllers/user_fb_controller.dart';
import '../../../../shared_preferences/shared_preferences.dart';
import '../../../widgets/my_button.dart';
import '../../../widgets/text_field.dart';
import '../../auth/login_screen.dart';
import 'dart:io';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with SnackBarHelper {
  late TextEditingController usernameEditingController;
  late TextEditingController mobileEditingController;
  late TextEditingController addressEditingController;
  @override
  void initState() {
    usernameEditingController = TextEditingController(
        text: SharedPreferencesController()
            .getter(type: String, key: SpKeys.username));
    mobileEditingController = TextEditingController(
        text: SharedPreferencesController()
            .getter(type: String, key: SpKeys.mobile));
    addressEditingController = TextEditingController(
        text: SharedPreferencesController()
            .getter(type: String, key: SpKeys.address));
    super.initState();
  }

  @override
  void dispose() {
    usernameEditingController.dispose();
    mobileEditingController.dispose();
    addressEditingController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  final credential = FirebaseAuth.instance.currentUser;
  var imagePicker = ImagePicker();
  File? file_;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b2d39),
        title: const Text('Personal Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 14.h
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Provider.of<AuthProvider>(context, listen: false)
                .avatar_
                .isNotEmpty
                ? CircleAvatar(
                radius: 55.w,
                backgroundImage: NetworkImage(
                    Provider.of<AuthProvider>(context).avatar_))
                : CircleAvatar(
                radius: 55.w,
                backgroundImage:
                const AssetImage('assets/images/avatar.jpg')),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 16.h),
                    Text(
                        'Name: ${SharedPreferencesController().getter(type: String, key: SpKeys.username)}',
                        style: TextStyle(color: Colors.black, fontSize: 16.sp)),
                    Text(
                      "Email: ${credential!.email} ",
                      style: TextStyle(
                        fontSize: 17.sp,
                      ),
                    ),
                    Text(
                      "Created date:  ${credential!.metadata.creationTime}   ",
                      style: TextStyle(
                        fontSize: 17.sp,
                      ),

                    ),
                    Text(
                      "Last Signed In: ${credential!.metadata.lastSignInTime}    ",
                      style: TextStyle(
                        fontSize: 17.sp,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      AppLocalizations.of(context)!.update,
                      style: TextStyle(
                        color: const Color(0xFF0b2d39),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Center(
                      child: TextInputField(
                        controller: usernameEditingController,
                        hint: 'test',
                        icon: Icons.person,
                        inputType: TextInputType.text,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: TextInputField(
                        controller: mobileEditingController,
                        hint: '+966 123456789',
                        icon: Icons.phone_android,
                        inputType: TextInputType.text,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SharedPreferencesController()
                                .getter(type: String, key: SpKeys.userType)
                                .toString() !=
                            UserTypes.patient.name
                        ? Center(
                          child: TextInputField(
                              controller: addressEditingController,
                              hint: 'location',
                              icon: Icons.location_on_rounded,
                              inputType: TextInputType.text,
                            ),
                        )
                        : const SizedBox.shrink(),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: MyButton(
                        buttonName: 'Update',
                        isLoading: isLoading,
                        onPressed: () async {
                          await performUpdate();
                        },
                      ),
                    ),


                    SizedBox(height: 18.h),
                    InkWell(
                        onTap: () async {
                          await Provider.of<LangProviders>(context, listen: false)
                              .changeLanguage();
                        },
                      child: Row(
                        children: [
                          Icon(Icons.language),
                          Text(
                            Provider.of<LangProviders>(context).lang_ == 'en' ? 'العربية':'Language',
                            style: TextStyle(
                                color: const Color(0xFF0b2d39),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                        ],
                      ),
                    ),
                  //  SizedBox(height: 18.h),

                    SharedPreferencesController()
                        .getter(type: String, key: SpKeys.userType)
                        .toString() ==
                        'patient'
                        ?
                    InkWell(
                      onTap: ()  {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                            const MedicalReportsScreen()));
                      },
                      child: Row(
                        children: [

                          Icon(Icons.file_copy_sharp),
                          Text(
                            AppLocalizations.of(context)!.myMedicalReports,
                            style: TextStyle(
                                color: const Color(0xFF0b2d39),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ):const SizedBox.shrink(),

                  //  SizedBox(height: 18.h),
                    InkWell(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        await FirebaseMessaging.instance.deleteToken();
                        await FirebaseMessaging.instance.unsubscribeFromTopic('updates');
                        await SharedPreferencesController().logout();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: Row(
                        children: [

                          Icon(Icons.logout),
                          Text(
                            AppLocalizations.of(context)!.logout,
                            style: TextStyle(
                                color: const Color(0xFF0b2d39),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: 10.h),
                    // MyButton(
                    //   buttonName: 'My Medical Reports',
                    //   isLoading: isLoading,
                    //   onPressed: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => const MedicalReportsScreen()));
                    //   },
                    // ),
                    // SizedBox(height: 10.h),
                    // MyButton(
                    //   buttonName: 'Change language',
                    //   isLoading: isLoading,
                    //   onPressed: () {
                    //     /// lang
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  File? imgPath;
  String? imgName;
  String? urlImg;

  choose2UploadImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(22),
            height: 200.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await uploadImage(ImageSource.camera);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 30,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'From Camera',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 22.h,
                ),
                InkWell(
                  onTap: () async {
                    await uploadImage(ImageSource.gallery);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.photo,
                        size: 30,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'From Gallery',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            ),
          );
        });
  }

  uploadImage(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        showSnackBar(context, message: "NO img selected", error: true);
      }
    } catch (e) {
      showSnackBar(context, message: "Error => $e", error: true);
    }
  }

  Future<void> performUpdate() async {
    if (checkData()) {
      await update();
    }
  }

  Future<void> update() async {
    setState(() {
      isLoading = true;
    });
    try {
      await UserFbController().updateUser(userModel);
      await Provider.of<AuthProvider>(context, listen: false)
          .setName_(usernameEditingController.text);
      await Provider.of<AuthProvider>(context, listen: false)
          .setMobile_(mobileEditingController.text);
      await Provider.of<AuthProvider>(context, listen: false)
          .setAvatar_(urlImg != null ? choose2UploadImage() : '');
      showSnackBar(context, message: 'success', error: false);
      Navigator.of(context).pop();
    } catch (c) {
      showSnackBar(context, message: 'failed', error: true);
    }
  }

  UserModel get userModel {
    UserModel user = UserModel();
    user.uId = SharedPreferencesController()
        .getter(type: String, key: SpKeys.uId)
        .toString();
    user.username = usernameEditingController.text;
    user.mobile = mobileEditingController.text;
    user.avatar = urlImg != null ? choose2UploadImage() : '';
    return user;
  }

  bool checkData() {
    if (usernameEditingController.text.isEmpty) {
      return false;
    } else if (mobileEditingController.text.isEmpty) {
      return false;
    }

    return true;
  }
}
