import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/models/major_model.dart';

class MajorFbController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MajorModel>> readMajor()async{
    try{
      var data = await _firestore.collection('majors').get();
      List<MajorModel> majors =[];
      for(int i=0; i < data.docs.length; i++){
        int successFound = majors.indexWhere((element) => element.id == data.docs[i].get('id'));
        if(successFound == -1){
          majors.add(MajorModel.fromMap(data.docs[i].data()));
        }
      }
      return majors;
    }catch(e){
      return [];
    }

  }
}