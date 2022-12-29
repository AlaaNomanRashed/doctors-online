import 'package:doctors_online/views/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/my_button.dart';
import '../../widgets/text_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>  {
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
                        hint: 'Email',
                        icon: Icons.lock,
                        inputType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                       TextInputField(
                        controller: passwordEditingController,
                        hint: 'Password',
                        icon: Icons.lock,
                        inputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                       MyButton(
                        onPressed: (){},
                        buttonName: 'Log In',
                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                        Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: const Color(0xFF0b2d39),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            width: 8.sp,
                          ),
                          InkWell(
                            onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const RegisterScreen()));
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







}
