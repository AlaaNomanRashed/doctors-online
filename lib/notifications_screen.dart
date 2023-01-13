import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/models/notifications_model.dart';
import 'package:doctors_online/views/widgets/no_data.dart';
import 'package:doctors_online/views/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase/controllers/notification_fb_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFa8d5e5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b2d39),
        title: const Text('Notifications '),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<NotificationsModel>>(
        stream:NotificationFbController().read() ,
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
            var notifications = snapshot.data!.docs;
return ListView.separated(
    shrinkWrap: true,
    padding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical:24.h,
    ),
    physics: const PageScrollPhysics(),
    itemBuilder:   (context, index) =>   NotificationItem(notificationsModel:notifications[index].data() ,),
    separatorBuilder: (context, index) => SizedBox(height: 10.h,),
    itemCount: notifications.length,
);
          }else{
            return const NoData();
          }


        },

      ),
    );
  }
}


