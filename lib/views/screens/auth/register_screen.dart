import 'package:doctors_online/models/city_model.dart';
import 'package:doctors_online/views/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' show basename;
import "dart:math";
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../firebase/controllers/user_fb_controller.dart';
import '../../../helpers/snackbar.dart';
import '../../../models/user_model.dart';
import '../../../providers/app_provider.dart';
import '../../widgets/my_button.dart';
import '../../widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SnackBarHelper {
  late TextEditingController usernameEditingController;
  late TextEditingController mobileEditingController;
  late TextEditingController emailEditingController;
  late TextEditingController passwordEditingController;
  late TextEditingController addressEditingController;

  @override
  void initState() {
    usernameEditingController = TextEditingController();
    mobileEditingController = TextEditingController();
    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
    addressEditingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameEditingController.dispose();
    mobileEditingController.dispose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
    addressEditingController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  UserTypes userType = UserTypes.patient;
  DateTime? myDob;
  int? myGender;
  late CityModel myCity = Provider.of<AppProvider>(context).cities_.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Stack(
                            children: [
                              imgPath == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.white54,
                                      radius: 70.w,
                                      backgroundImage: const AssetImage(
                                          'assets/images/avatar.jpg'),
                                    )
                                  : ClipOval(
                                      child: Image.file(
                                        imgPath!,
                                        width: 145.w,
                                        height: 145.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              Positioned(
                                right: 95,
                                bottom: -10,
                                child: IconButton(
                                  onPressed: () {
                                    choose2UploadImage();
                                  },
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 30.r,
                                  ),
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 24.h,
                        ),
                        TextInputField(
                          controller: usernameEditingController,
                          hint: 'username',
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
                        TextInputField(
                          controller: emailEditingController,
                          hint: 'username@gmail.com',
                          icon: Icons.email,
                          inputType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),

                        /// password
                        TextInputField(
                          controller: passwordEditingController,
                          hint: '******',
                          icon: Icons.lock,
                          inputType: TextInputType.text,
                        ),

                        // SizedBox(
                        //   height: 10.h,
                        // ),
                        ///Todo ==> optional Gender

                        SizedBox(
                          height: 10.h,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          /// DoB ==> Patient
                          child: userType == UserTypes.patient
                              ? InkWell(
                                  onTap: () async {
                                    DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                      initialEntryMode:
                                          DatePickerEntryMode.calendarOnly,
                                      builder: (BuildContext context,
                                              Widget? child) =>
                                          Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Color(0xFF0b2d39),
                                            onPrimary: Colors.white,
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      ),
                                    );
                                    if (newDate == null) return;
                                    setState(() {
                                      myDob = newDate;
                                    });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500]!.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 16.w,
                                          ),
                                          Text(
                                            myDob == null
                                                ? 'date of birth'
                                                : '${myDob!.day}/${myDob!.month}/${myDob!.year}',
                                            style: const TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              : TextInputField(
                                  controller: addressEditingController,
                                  hint: 'address city',
                                  icon: Icons.location_history,
                                  inputType: TextInputType.text,
                                ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),

                        /// city==>Patient
                        // Container(
                        //   height: MediaQuery.of(context).size.height * 0.08,
                        //   width: MediaQuery.of(context).size.width * 0.8,
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey[500]!.withOpacity(0.5),
                        //     borderRadius: BorderRadius.circular(16),
                        //   ),
                        //   child:DropdownButton(
                        //     items:Provider.of<AppProvider>(context,listen: false).cities_
                        //         .map((city) => DropdownMenuItem(
                        //       value: city,
                        //       child: Text(
                        //         city.nameEn!
                        //       ),
                        //     ),
                        //     )
                        //         .toList(),
                        //     value: myCity,
                        //     onChanged: (_) {
                        //       setState(() {
                        //         myCity = _!;
                        //       });
                        //     },
                        //     underline: const SizedBox(),
                        //     isExpanded: true,
                        //     focusColor: Colors.transparent ,
                        //   ),
                        // ),
                        //

                        /////////////////
                        SizedBox(
                          height: 15.h,
                        ),
                        MyButton(
                          buttonName: 'Register',
                          isLoading: isLoading,
                          onPressed: () async {
                            await performRegister();
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'already have an account?',
                              style: TextStyle(
                                color: const Color(0xFF0b2d39),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8.sp,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                              },
                              child: Text(
                                '-Login',
                                style: TextStyle(
                                  color: const Color(0xFF0b2d39),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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

  Future<void> performRegister() async {
    if (checkData()) {
      await register();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  late final UserCredential userCredential;

  Future<void> register() async {
    setState(() {
      isLoading = true;
    });
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailEditingController.text,
        password: passwordEditingController.text,
      );

      /// todo مراجعة
      // final storageRef = FirebaseStorage.instance.ref(imgName);
      // await storageRef.putFile(imgPath!);
      // urlImg = await storageRef.getDownloadURL();

      /// todo end
      await createNewUser();
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        showSnackBar(context,
            message: 'The password provided is too weak.', error: true);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context,
            message: 'The account already exists for that email.', error: true);
      } else {
        showSnackBar(context,
            message: 'Error , Please try again late', error: true);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, message: e.toString(), error: true);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> createNewUser() async {
    await UserFbController().createUser(getUser);
    showSnackBar(context,
        message: 'create account has been successfully', error: false);
    Navigator.of(context).pop();
  }

  UserModel get getUser {
    UserModel userModel = UserModel();
    userModel.uId = userCredential.user!.uid;
    userModel.username = usernameEditingController.text;
    userModel.email = emailEditingController.text;
    userModel.mobile = mobileEditingController.text;
    userModel.password = passwordEditingController.text;
    userModel.avatar = urlImg ?? '';
    userModel.dob =
        myDob != null ? '${myDob!.day}/${myDob!.month}/${myDob!.year}' : '';
    // userModel.gender = myGender ?? -1;
    userModel.address = addressEditingController.text;
    userModel.type = userType.name;
    userModel.medicalReports = [];
    userModel.cityId = myCity.id as String;
    return userModel;
  }

  bool checkData() {
    if (usernameEditingController.text.isEmpty) {
      showSnackBar(context,
          message: 'The username must be not empty.', error: true);
      return false;
    } else if (mobileEditingController.text.isEmpty) {
      showSnackBar(context,
          message: 'The mobile phone must be not empty.', error: true);
      return false;
    } else if (emailEditingController.text.isEmpty) {
      showSnackBar(context,
          message: 'The email address must be not empty.', error: true);
      return false;
    } else if (passwordEditingController.text.isEmpty) {
      showSnackBar(context,
          message: 'The password must be not empty.', error: true);
      return false;
    } else if (userType == UserTypes.patient && myDob == null) {
      showSnackBar(context, message: 'Enter your date of birth.', error: true);
      return false;
    } else if (imgName == null && imgPath == null) {
      showSnackBar(context,
          message: 'add photo to login profile.', error: true);
      return false;
    }
    return true;
  }
}
