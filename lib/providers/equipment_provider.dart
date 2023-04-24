import 'package:flutter/material.dart';
import 'package:mielevaso_app/models/equipment_model.dart';

final List<Equipment> initialData = List.generate(
    50,
        (index) => Equipment(category: 'sword', name: '어비스', img_url: 'https://', level: '85', reinforcement: 15));

class EquipmentProvider with ChangeNotifier{
  final List<Equipment> _equipments = initialData;
  List<Equipment> get equipments => _equipments;
}