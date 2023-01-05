enum UserTypes {
  patient,
  doctor,
  pharmacy,
}
enum SpKeys {
  loggedIn,
  lang,
  fcmToken,
  uId,
  userType,
  username,
  email,
  mobile,
  avatar,
  cityId,
  address,
}

enum ConsultationStatus {
  // قيد الانتظار
  waiting,

  // حذف الطلب من قبل المريض
  deleted,

  //  تم الرفض من ثبل الطبيب
  rejected,

  // قيد المراجعة
  inProgress,

  // تم تحويل الطلب للتوجه الى اقرب صيديلة
  transferred,

  // تم صرف الرشيتة من الصيدلية
  completed,
}
