import 'package:doctors_online/models/consultation_model.dart';
import 'package:flutter/material.dart';

class ConsultationActionIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final ConsultationStatus status;
  final bool isLoading;
  final Function() onTap;
  const ConsultationActionIcon({
    Key? key, required this.text, required this.icon,this.isLoading=false, required this.onTap, required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children:[
           Icon(
            icon,
             color: consultationStatusColor(status.name),
          ),
       !isLoading?   Text(consultationStatusText(context, text)):const CircularProgressIndicator(color: Colors.white,),
        ],
      ),
    );
  }


}