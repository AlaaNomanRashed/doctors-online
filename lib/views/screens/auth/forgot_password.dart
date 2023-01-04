import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../helpers/snackbar.dart';
import '../../widgets/my_button.dart';
import '../../widgets/text_field.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with SnackBarHelper{
  late TextEditingController emailEditingController;
  @override
  void initState() {
    emailEditingController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    emailEditingController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0b2d39),
        title: Text('Forgot Password'),
        centerTitle: true,
      ),
     // resizeToAvoidBottomInset: false,

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
                      Text(
                        'Enter your email to reset your password',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: const Color(0xFF0b2d39),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      TextInputField(
                        controller: emailEditingController,
                        hint: 'test@gmail.com',
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                      ),

                      SizedBox(
                        height: 40.h,
                      ),
                      MyButton(
                        buttonName: 'Reset Password',
                        isLoading: isLoading,
                        onPressed: ()async{
                         await performResetPassword();
                        },

                      ),
                      SizedBox(
                        height: 20.h,
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

  Future<void> performResetPassword() async {
    if (checkData()) {
      await resetPassword();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }
  Future<void> resetPassword() async{
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailEditingController.text);
      showSnackBar(context, message: 'Done , check your email', error: false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, message: e.toString(), error: true);
    }catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, message: e.toString(), error: true);
    }
    setState(() {
      isLoading = false;
    });


  }

  bool checkData() {
    if (emailEditingController.text.isEmpty) {
      showSnackBar(context,
          message: 'The email address must be not empty.', error: true);
      return false;
    }
    return true;
  }
}
