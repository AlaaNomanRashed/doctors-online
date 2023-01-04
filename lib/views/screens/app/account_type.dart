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
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton(
              buttonName: 'Doctor',
              isLoading: isLoading,
              onPressed: (){
                ///ToDo Go To Doctor Screen
              },
            ),
            SizedBox(height: 14.h,),
            MyButton(
              buttonName: 'Patient',
              isLoading: isLoading,
              onPressed: (){
                ///ToDo Go To Patient Screen
              },
            ),
            SizedBox(height: 14.h,),
            MyButton(
              buttonName: 'Pharmacy',
              isLoading: isLoading,
              onPressed: (){
                ///ToDo Go To Pharmacy Screen
              },
            ),

          ],
        ),
      ),
    );
  }
}
