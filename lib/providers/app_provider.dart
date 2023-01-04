import 'package:doctors_online/models/consultation_model.dart';
import 'package:flutter/cupertino.dart';
import '../models/city_model.dart';
import '../models/major_model.dart';

class AppProvider extends ChangeNotifier{
    /// City
  List<CityModel> cities_ =[];
  void setCities(List<CityModel> list){
    cities_ = list;
    notifyListeners();
  }

  /// Consultation
  List<ConsultationModel> consultation_ =[];
  void setConsultation(List<ConsultationModel> list){
    consultation_ = list;
    notifyListeners();
  }

  /// Major
  List<MajorModel> majors_ =[];
  void setMajor(List<MajorModel> list){
    majors_ = list;
    notifyListeners();
  }

 



}