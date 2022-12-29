import 'package:doctors_online/views/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/my_button.dart';
import '../../widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController usernameEditingController;
  late TextEditingController mobileEditingController;
  late TextEditingController emailEditingController;
  late TextEditingController passwordEditingController;

  @override
  void initState() {
    usernameEditingController = TextEditingController();
    mobileEditingController = TextEditingController();
    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameEditingController.dispose();
    mobileEditingController.dispose();
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
                        hint: 'test',
                        icon: Icons.person,
                        inputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      TextInputField(
                        controller: mobileEditingController,
                        hint: '+966 123456789',
                        icon: Icons.phone_android,
                        inputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      TextInputField(
                        controller: emailEditingController,
                        hint: 'test@gmail.com',
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      TextInputField(
                        controller: passwordEditingController,
                        hint: '******',
                        icon: Icons.phone_android,
                        inputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                       MyButton(
                         onPressed: (){},
                        buttonName: 'Register',
                      ),
                      Row(
                        children: [
                          Text(
                            'already have an account',
                            style: TextStyle(
                              color: const Color(0xFF0b2d39),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: const Color(0xFF0b2d39),
                                fontSize: 20.sp,
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
}
