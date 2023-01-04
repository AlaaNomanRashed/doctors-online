import 'dart:math';
import 'package:path/path.dart' show basename;
import 'package:doctors_online/firebase/controllers/user_fb_controller.dart';
import 'package:doctors_online/models/user_model.dart';
import 'package:doctors_online/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../helpers/snackbar.dart';
import '../../../shared_preferences/shared_preferences.dart';
import '../../widgets/my_button.dart';
import '../../widgets/text_field.dart';
import '../auth/login_screen.dart';

class ModifyProfileScreen extends StatefulWidget {
  const ModifyProfileScreen({Key? key}) : super(key: key);

  @override
  State<ModifyProfileScreen> createState() => _ModifyProfileScreenState();
}

class _ModifyProfileScreenState extends State<ModifyProfileScreen>
    with SnackBarHelper {
  late TextEditingController usernameEditingController;
  late TextEditingController mobileEditingController;
  late TextEditingController addressEditingController;
  @override
  void initState() {
    usernameEditingController =
        TextEditingController(text: SharedPreferencesController().getter(type: String, key: SpKeys.username));
    mobileEditingController =
        TextEditingController(text: SharedPreferencesController().getter(type: String, key: SpKeys.mobile));
    addressEditingController =
        TextEditingController(text: SharedPreferencesController().getter(type: String, key: SpKeys.address));
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
  var imagePicker = ImagePicker();
  File? file_;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await FirebaseMessaging.instance.deleteToken();
              await SharedPreferencesController().logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginScreen()));
            },
            label: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: const Color(0xFF0b2d39),
        title: const Text('Modify Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60.h,
            ),

            /// todo update img profile
            ///
            TextInputField(
              controller: usernameEditingController,
              hint: 'test',
              icon: Icons.person,
              inputType: TextInputType.text,
            ),
            SizedBox(
              height: 10.h,
            ),
            TextInputField(
              controller: mobileEditingController,
              hint: '+966 123456789',
              icon: Icons.phone_android,
              inputType: TextInputType.text,
            ),
            SizedBox(
              height: 10.h,
            ),
           SharedPreferencesController().getter(type: String, key: SpKeys.userType).toString() != UserTypes.patient.name ?
            TextInputField(
              controller: addressEditingController,
              hint: 'location',
              icon: Icons.location_history_outlined,
              inputType: TextInputType.text,
            ): const SizedBox.shrink(),
            SizedBox(
              height: 16.h,
            ),
            MyButton(
              buttonName: 'Update',
              isLoading: isLoading,
              onPressed: () async {
                await performUpdate();
              },
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
          .setAvatar_(urlImg != null ?  choose2UploadImage() : '');
      showSnackBar(context, message: 'success', error: false);
      Navigator.of(context).pop();
    } catch (c) {
      showSnackBar(context, message: 'failed', error: true);
    }
  }

  UserModel get userModel {
    UserModel user = UserModel();
    user.uId = SharedPreferencesController().getter(type: String, key: SpKeys.uId).toString();
    user.username = usernameEditingController.text;
    user.mobile = mobileEditingController.text;
    user.avatar=  urlImg != null ?  choose2UploadImage() : '';
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
