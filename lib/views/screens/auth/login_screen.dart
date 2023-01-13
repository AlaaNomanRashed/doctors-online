import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/enums.dart';
import 'package:doctors_online/providers/auth_provider.dart';
import 'package:doctors_online/views/screens/app/user/account_type.dart';
import 'package:doctors_online/views/screens/auth/forgot_password.dart';
import 'package:doctors_online/views/screens/auth/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../firebase/controllers/user_fb_controller.dart';
import '../../../helpers/snackbar.dart';
import '../../../shared_preferences/shared_preferences.dart';
import '../../widgets/my_button.dart';
import '../../widgets/text_field.dart';
import '../app/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SnackBarHelper {
  late TextEditingController emailEditingController;
  late TextEditingController passwordEditingController;

  @override
  void initState() {
    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  bool isLoading = false;

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60.h,
                      ),
                      TextInputField(
                        controller: emailEditingController,
                        hint: 'test@gmail.com',
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextInputField(
                        controller: passwordEditingController,
                        hint: '******',
                        icon: Icons.lock,
                        inputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      MyButton(
                        buttonName: 'Log In',
                        isLoading: isLoading,
                        onPressed: () async {
                          await performLogin();
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: const Color(0xFF0b2d39),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an Account ?',
                            style: TextStyle(
                                color: const Color(0xFF134b5f),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 8.sp,
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) =>
                              //         const RegisterScreen()));

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const AccountType()));
                            },
                            child: Text(
                              '-Register',
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
        ],
      ),
    );
  }

  Future<void> performLogin() async {
    if (checkData()) {
      await login();
    }
  }

  late UserCredential userCredential;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailEditingController.text,
        password: passwordEditingController.text,
      );

      /// Get User Data
      // await getUserData(userCredential.user!.uid);
      await saveUserData(userCredential.user!.uid);
      await SharedPreferencesController()
          .setter(type: bool, key: SpKeys.loggedIn, value: true);

      setState(() {
        isLoading = false;
      });
      showSnackBar(context,
          message: 'i have successfully logged in', error: false);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        showSnackBar(context,
            message: 'No user found for that email.', error: true);
      } else if (e.code == 'wrong-password') {
        showSnackBar(context,
            message: 'Wrong password provided for that user.', error: true);
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

  // Future<void> getUserData(String uId) async {
  //   /// Get user model from Firestore
  //   var data = await UserFbController().readUser(uId);
  //
  //   if(data != null) {
  //     /// Save user data in Shared Preferences
  //     await SharedPreferencesController().setEmail(email: data.email);
  //     await SharedPreferencesController().setUserType(type: data.type);
  //     await SharedPreferencesController().setUId(id: uId);
  //
  //   }
  // }

  CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUserData(String uId) async {
    await userCollectionReference.doc(uId).get().then((doc) async {
      if (doc.exists) {
        await SharedPreferencesController()
            .setter(type: String, key: SpKeys.userType, value: doc.get('type'));
        await SharedPreferencesController()
            .setter(type: String, key: SpKeys.uId, value: doc.get('uId'));
        Provider.of<AuthProvider>(context, listen: false)
            .setName_(doc.get('username'));
        Provider.of<AuthProvider>(context, listen: false)
            .setMobile_(doc.get('mobile'));
        Provider.of<AuthProvider>(context, listen: false)
            .setAvatar_(doc.get('avatar'));
        await SharedPreferencesController()
            .setter(type: int, key: SpKeys.cityId, value: doc.get('cityId'));
        await SharedPreferencesController().setter(
            type: String, key: SpKeys.address, value: doc.get('address'));
        var fcmToken = await FirebaseMessaging.instance.getToken();
        await SharedPreferencesController()
            .setter(type: String, key: SpKeys.fcmToken, value: fcmToken ?? '');
        await UserFbController().updateFCMToken(
          uId,
          fcmToken ?? '',
        );
      }
    });
  }

  bool checkData() {
    if (emailEditingController.text.isEmpty) {
      showSnackBar(context,
          message: 'The email address must be not empty.', error: true);
      return false;
    } else if (passwordEditingController.text.isEmpty) {
      showSnackBar(context,
          message: 'The password must be not empty.', error: true);
      return false;
    }
    return true;
  }
}
