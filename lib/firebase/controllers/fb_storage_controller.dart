import 'dart:io';

import 'package:doctors_online/helpers/snackbar.dart';
import 'package:doctors_online/shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

typedef CallBackUrl = void Function({
  required String url,
  required bool status,
  required TaskState taskState,
});

class FbStorageController with SnackBarHelper {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadMedicalReports({
    required File file,
    required BuildContext context,
    required CallBackUrl callBackUrl,
  }) async {
    // Upload image
    UploadTask uploadTask = _firebaseStorage
        .ref(
            'MedicalReports/${SharedPreferencesController().getter(type: String, key: SpKeys.userType)}/${SharedPreferencesController().getter(type: String, key: SpKeys.uId)}/${DateTime.now()}image')
        .putFile(file);
/// Get Image URL
    uploadTask.snapshotEvents.listen((event) async {
      /// if something changes -->
      if (event.state == TaskState.running) {
      } else if (event.state == TaskState.success) {
        Reference imageReference = event.ref;
        var downloadURL = await imageReference.getDownloadURL();
        callBackUrl(
          url: downloadURL,
          status: true,
          taskState: event.state,
        );
      } else if (event.state == TaskState.error) {
      ///  showSnackBar(context, message: '${TaskState.error}', error: true);
      }
    });
  }
}
