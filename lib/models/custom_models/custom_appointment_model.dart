import 'package:flutter/material.dart';

class CustomAppointmentModel {
  late String id;
  late TextEditingController nameEditingController;
  late TextEditingController noteEditingController;
  late List<TimeOfDay> times;

  CustomAppointmentModel({
    required this.id,
    required this.nameEditingController,
    required this.noteEditingController,
    required this.times,
  });

}
