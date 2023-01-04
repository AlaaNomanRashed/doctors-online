import 'package:flutter/material.dart';

mixin SnackBarHelper {
  void showSnackBar(
      BuildContext context, {
        required String message,
        required bool error,
        int duration = 2,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor:
        error ? const Color(0xffff4d4f) : const Color(0xff52c41a),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        margin: EdgeInsets.zero,
        elevation: 10,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
