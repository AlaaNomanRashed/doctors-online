import 'package:doctors_online/models/consultation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/app/consultation/consultation_details.dart';

class ConsultationsItem extends StatefulWidget {
  final ConsultationModel consultationModel;

  ConsultationsItem({Key? key, required this.consultationModel})
      : super(key: key);

  @override
  State<ConsultationsItem> createState() => _ConsultationsItemState();
}

class _ConsultationsItemState extends State<ConsultationsItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ConsultationDetails(
                consultationModel: widget.consultationModel)));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(width: 1.w, color: Colors.black)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12.sp,
                  ),
                ),
                Chip(
                  label: Text(consultationStatusText(
                      context, widget.consultationModel.requestStatus ?? '')),
                  backgroundColor: consultationStatusColor(
                          widget.consultationModel.requestStatus ?? '')
                      .withOpacity(0.7),
                  padding: EdgeInsets.zero,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            Text(
              widget.consultationModel.note ?? '',
              style: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.w600, height: 1.h),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String get date {
    return '${widget.consultationModel.timestamp.toDate().year}/${widget.consultationModel.timestamp.toDate().month}/${widget.consultationModel.timestamp.toDate().day}';
  }
}
