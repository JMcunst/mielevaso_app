import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EquipmentDetailDialog extends StatelessWidget {
  final Map<String, dynamic> equipment;

  EquipmentDetailDialog({required this.equipment});

  String _mapSetTypeName(String code) {
    switch (code) {
      case "ATK":
        return "공격";
      case "DEF":
        return "방어";
      case "HLP":
        return "생명";
      case "SPD":
        return "속도";
      case "CTR":
        return "치확";
      case "DES":
        return "파멸";
      case "HTR":
        return "적중";
      case "RES":
        return "저항";
      case "LFS":
        return "흡혈";
      case "CNT":
        return "반격";
      case "DUA":
        return "협공";
      case "IMM":
        return "면역";
      case "RAG":
        return "분노";
      case "PEN":
        return "관통";
      case "REV":
        return "복수";
      case "INJ":
        return "상처";
      case "TOR":
        return "격류";
      case "PRO":
        return "수호";
      default:
        return "";
    }

  }
  String _mapSubStatTypeName(String code) {
    switch (code) {
      case "HPP":
      case "HPS":
        return "생명력";
      case "DFP":
      case "DFS":
        return "방어력";
      case "ATP":
      case "ATS":
        return "공격력";
      case "CHC":
        return "치명확률";
      case "CHD":
        return "치명피해";
      case "EFV":
        return "효과적중";
      case "EFR":
        return "효과저항";
      case "SPD":
        return "속도";
      default:
        return "";
    }
  }

  String generateSubStatText(String type, int point) {
    String convType = _mapSubStatTypeName(type);
    return '$convType: ${point.toStringAsFixed(0)}${type != 'HPP' && type != 'DFP' && type != 'ATP' && type != 'SPD' ? '%' : ''}';
  }

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
            Text('아이템 레벨: ${equipment['level']}'),
            Text('등급: ${equipment['grade']}'),
            Text('강화: ${equipment['reinforced'].toStringAsFixed(0)} 강'),
            Text('제련여부: ${equipment['is_blacksmith']}'),
            Text('세트: ${_mapSetTypeName(equipment['set'])}'),
            Row(
              children: [
                Text(generateSubStatText(equipment['main_st_ty'], equipment['main_st_pt'])),
              ],
            ),
            Row(
              children: [
                Text(generateSubStatText(equipment['sub_st1_ty'], equipment['sub_st1_pt'])),
              ],
            ),
            Row(
              children: [
                Text(generateSubStatText(equipment['sub_st2_ty'], equipment['sub_st2_pt'])),
              ],
            ),
            Row(
              children: [
                Text(generateSubStatText(equipment['sub_st3_ty'], equipment['sub_st3_pt'])),
              ],
            ),
            Row(
              children: [
                Text(generateSubStatText(equipment['sub_st4_ty'], equipment['sub_st4_pt'])),
              ],
            ),
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
