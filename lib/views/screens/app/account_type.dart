import 'package:doctors_online/enums.dart';
import 'package:doctors_online/views/screens/auth/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/my_button.dart';

class AccountType extends StatefulWidget {
  const AccountType({Key? key}) : super(key: key);

  @override
  State<AccountType> createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: UserTypes.values.map((userType) {
            return Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: MyButton(
                buttonName: userType == UserTypes.patient
                    ? 'Patient'
                    : userType == UserTypes.doctor
                        ? 'Doctor'
                        : 'Pharmacy',
                // isLoading: isLoading,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegisterScreen(userType: userType)));
                },
              ),
            );
          }).toList(),
          // children: [
          //   MyButton(
          //     buttonName: 'Doctor',
          //     // isLoading: isLoading,
          //     onPressed: () {
          //       ///ToDo Go To Doctor Screen
          //     },
          //   ),
          //   SizedBox(height: 14.h),
          //   MyButton(
          //     buttonName: 'Patient',
          //     onPressed: () {
          //       ///ToDo Go To Patient Screen
          //     },
          //   ),
          //   SizedBox(height: 14.h),
          //   MyButton(
          //     buttonName: 'Pharmacy',
          //     onPressed: () {
          //       ///ToDo Go To Pharmacy Screen
          //     },
          //   ),
          // ],
        ),
      ),
    );
  }
}
