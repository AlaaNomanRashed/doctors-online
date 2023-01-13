import 'package:doctors_online/models/notifications_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../firebase/controllers/notification_fb_controller.dart';

class NotificationItem extends StatelessWidget {
  final NotificationsModel notificationsModel;
  const NotificationItem({
    Key? key, required this.notificationsModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction)async{
        await delete();
      },
      background: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.delete, color: Colors.red,),
          Icon(Icons.delete, color: Colors.red,),
        ],
      ),
      child: Container(
        width: double.infinity ,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              width: 1.w,
              color: const Color(0xFF0b2d39),

            ),
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(
                    notificationsModel.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                  ),
                )),
                Text('${notificationsModel.timestamp.toDate().year}/${notificationsModel.timestamp.toDate().month}/${notificationsModel.timestamp.toDate().day}  ${notificationsModel.timestamp.toDate().hour}:${notificationsModel.timestamp.toDate().minute}:${notificationsModel.timestamp.toDate().second}' ,
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500
                  ),)
              ],
            ),
            Text(notificationsModel.body,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500
              ),),
          ],
        ) ,
      ),
    );
  }

  Future<void> delete()async{
    try{
await NotificationFbController().delete(notificationsModel.id);
    }catch(e){

    }
  }
}