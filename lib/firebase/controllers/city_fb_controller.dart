import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/models/city_model.dart';

class CityFbController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CityModel>> readCities()async{
    try{

      var data = await _firestore.collection('cities').get();

      List<CityModel> cities =[];

      for(int i=0; i < data.docs.length; i++){
        int successFound = cities.indexWhere((element) => element.id == data.docs[i].get('id'));
        if(successFound == -1){
         cities.add(CityModel.fromMap(data.docs[i].data()));
        }
      }
      return cities;
    }catch(e){
      return [];
    }

  }
}