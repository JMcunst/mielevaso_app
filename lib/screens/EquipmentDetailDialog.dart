import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EquipmentDetailDialog extends StatelessWidget {
  final Map<String, dynamic> equipment;

  EquipmentDetailDialog({required this.equipment});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(equipment['name']),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              equipment['img_url'],
              width: 128,
              height: 128,
            ),
            SizedBox(height: 16.0),
            Text('모델명: ${equipment['level']}'),
            Text('제조사: ${equipment['grade']}'),
            Text('가격: ${equipment['score'].toStringAsFixed(0)} 원'),
            Text('가격: ${equipment['score'].toStringAsFixed(0)} 원'),
            Text('가격: ${equipment['score'].toStringAsFixed(0)} 원'),
            Text('가격: ${equipment['score'].toStringAsFixed(0)} 원'),
            Text('가격: ${equipment['score'].toStringAsFixed(0)} 원'),
            Text('가격: ${equipment['score'].toStringAsFixed(0)} 원'),
            Text('가격: ${equipment['score'].toStringAsFixed(0)} 원'),
            Text('가격: ${equipment['score'].toStringAsFixed(0)} 원'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('확인'),
        ),
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('equipments').doc(equipment['id']).delete();
            Navigator.pop(context);
          },
          child: Text('삭제'),
        ),
      ],
    );
  }
}
