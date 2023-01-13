import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListTileItemDrawer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;
  const ListTileItemDrawer({
    Key? key, required this.title, required this.icon, required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        leading:  Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        onTap:onTap
        );
  }
}