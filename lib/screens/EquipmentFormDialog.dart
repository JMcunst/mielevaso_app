import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EquipmentFormDialog extends StatefulWidget {
  const EquipmentFormDialog({Key? key}) : super(key: key);

  @override
  _EquipmentFormDialogState createState() => _EquipmentFormDialogState();
}

class _EquipmentFormDialogState extends State<EquipmentFormDialog> {
  String _categoryNameValue = '어비스 드레이크 뼈날검';
  late List<String> _categoryNames;

  List<DropdownMenuItem<String>>? _categoryNameItems;
  final List<String> _categoryFormField = ['sword', 'helmet', 'armor', 'necklace', 'ring', 'shoes'];
  String _categoryValue = 'sword';
  final Map<String, List<String>> _categoryNameLists = {
    'sword': ['에이션트 드레이크 뼈날검', '검은 영혼의 양날 검','에이키르 제사장의 지팡이','어둠강철 검','저주받은 악마의 양날 검','지옥파멸 정수 오브', '어비스 드레이크 뼈날검'],
    'helmet': ['Plate Helm', 'Leather Hood', 'Chain Coif'],
    'armor': ['Chainmail', 'Platemail', 'Leather Armor'],
    'necklace': ['Amulet of Power', 'Necklace of Sorcery'],
    'ring': ['Ring of Protection', 'Ring of Regeneration'],
    'shoes': ['Leather Boots', 'Steel Sabatons'],
  };
  final List<String> _convertedField = ['없음', '1번째', '2번째', '3번째', '4번째'];
  String _convertedFormValue = '없음';
  final List<String> _levelField = ['90', '88', '85', '80', '78','75','71','70'];
  String _levelValue = '85';
  final List<String> _gradeFormField = ['전설', '영웅', '희귀', '일반'];
  String _gradeValue = '전설';
  final List<String> _isBalcksmithFormField = ['가능', '불가능', '제련됨'];
  String _isBalcksmithValue = '불가능';
  final List<Map<String, String>> _statTypeFormField = [
    {'code': 'HPP', 'title': '생명력'},
    {'code': 'HPS', 'title': '생명력(%)'},
    {'code': 'DFP', 'title': '방어력'},
    {'code': 'DFS', 'title': '방어력(%)'},
    {'code': 'ATP', 'title': '공격력'},
    {'code': 'ATS', 'title': '공격력(%)'},
    {'code': 'CHC', 'title': '치명확률'},
    {'code': 'CHD', 'title': '치명피해'},
    {'code': 'EFV', 'title': '효과적중'},
    {'code': 'EFR', 'title': '효과저항'},
    {'code': 'SPD', 'title': '속도'}
  ];
  int _mainStatPoint = 0;
  String _mainStatValue = 'HPP';
  int _subStatPointOne = 0;
  String _subStatValueOne = 'HPS';
  int _subStatPointTwo = 0;
  String _subStatValueTwo = 'HPS';
  int _subStatPointThree = 0;
  String _subStatValueThree = 'HPS';
  int _subStatPointFour = 0;
  String _subStatValueFour = 'HPS';
  String _name = '';
  final int _reinforced = 15;
  final List<Map<String, String>> _setTypeFormField = [
    {'code': 'ATK', 'title': '공격'},
    {'code': 'DEF', 'title': '방어'},
    {'code': 'HLP', 'title': '생명'},
    {'code': 'SPD', 'title': '속도'},
    {'code': 'CTR', 'title': '치확'},
    {'code': 'DES', 'title': '파멸'},
    {'code': 'HTR', 'title': '적중'},
    {'code': 'RES', 'title': '저항'},
    {'code': 'LFS', 'title': '흡혈'},
    {'code': 'CNT', 'title': '반격'},
    {'code': 'DUA', 'title': '협공'},
    {'code': 'IMM', 'title': '면역'},
    {'code': 'RAG', 'title': '분노'},
    {'code': 'PEN', 'title': '관통'},
    {'code': 'REV', 'title': '복수'},
    {'code': 'INJ', 'title': '상처'},
    {'code': 'TOR', 'title': '격류'},
    {'code': 'PRO', 'title': '수호'}
  ];
  String _setType = 'ATK';

  double calEquipmentScore() {
    double score = 0.0;

    // TODO: GET SCORE LOGIC
    return score;
  }

  List<String> _getCategoryNameList(String categoryValue) {
    return _categoryNameLists[categoryValue] ?? _categoryNameLists['sword']!;
  }

  List<DropdownMenuItem<String>> _getCategoryNameItems() {
    final categoryNameList = _categoryNameLists[_categoryValue] ?? _categoryNameLists['sword']!;
    return categoryNameList
        .map((value) => DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    ))
        .toList();
  }

  void _submitForm() async {
    String img_url_path = 'equipments/${_categoryValue}s/$_categoryNameValue.png';
    print('aaaaaaaaa:$img_url_path');
    final storageRef = FirebaseStorage.instance.ref().child(img_url_path);
    final imageUrl = await storageRef.getDownloadURL();

    // Firebase에 값을 저장
    final user = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();
    double score_equipment = calEquipmentScore();
    final setData = {
      "name": _categoryNameValue,
      "level": _levelValue,
      "category": _categoryValue,
      "converted": _convertedFormValue,
      "grade": _gradeValue,
      "reinforced": _reinforced,
      "set": _setType,
      "is_blacksmith": _isBalcksmithValue,
      "main_st_ty": _mainStatValue,
      "main_st_pt": _mainStatPoint,
      "sub_st1_ty": _subStatValueOne,
      "sub_st1_pt": _subStatPointOne,
      "sub_st2_ty": _subStatValueTwo,
      "sub_st2_pt": _subStatPointTwo,
      "sub_st3_ty": _subStatValueThree,
      "sub_st3_pt": _subStatPointThree,
      "sub_st4_ty": _subStatValueFour,
      "sub_st4_pt": _subStatPointFour,
      "score": score_equipment,
      "status": true,
      "created_at": now,
      "update_at": now,
      "img_url": imageUrl
    };
    print('SSSSSSS$setData');

    await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user!.uid)
        .collection(_categoryValue + 's')
        .doc(_categoryValue)
        .update({
      "datas": FieldValue.arrayUnion([setData])
    });
    final scaffoldContext = context;
    if (scaffoldContext != null) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(
          content: Text('성공적으로 생성 되었습니다.'),
        ),
      );
    }
    // 다이얼로그 닫기
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _categoryNames = _getCategoryNameList(_categoryValue);
    _categoryNameValue = _categoryNames[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('장비 정보 추가'),
      content: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField(
                decoration:
                const InputDecoration(labelText: 'Category'),
                value: _categoryValue,
                items: _categoryFormField.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _categoryValue = value ?? 'sword';
                    _categoryNameValue = _categoryNameLists[_categoryValue]![0]; // reset the selected name value
                    _categoryNameItems = _getCategoryNameItems();
                  });
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'CategoryName'),
                value: _categoryNameValue,
                items: _categoryNameItems,
                onChanged: (String? value) {
                  setState(() {
                    _categoryNameValue = value ?? _categoryNameLists[_categoryValue]![0];
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '강화'),
                initialValue: _reinforced.toString(),
                enabled: false,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Grade'),
                value: _gradeValue,
                items: _gradeFormField.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _gradeValue = value ?? '전설';
                  });
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Level'),
                value: _levelValue,
                items: _levelField.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _levelValue = value ?? '85';
                  });
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '제련 여부'),
                value: _isBalcksmithValue,
                items: _isBalcksmithFormField.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _isBalcksmithValue = value ?? '불가능';
                  });
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Set'),
                value: _setType,
                items: _setTypeFormField.map((item) {
                  return DropdownMenuItem(
                    value: item['code'],
                    child: Text(item['title']!),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _setType = value ?? 'ATK';
                  });
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '메인옵'),
                value: _mainStatValue,
                items: _statTypeFormField.map((item) {
                  return DropdownMenuItem(
                    value: item['code'],
                    child: Text(item['title']!),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _mainStatValue = value ?? 'HPP';
                  });
                },
              ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: '메인옵 포인트'),
                initialValue: _mainStatPoint.toString(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a main point';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (value != null) {
                    _mainStatPoint = int.parse(value);
                  }
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '부옵1'),
                value: _subStatValueOne,
                items: _statTypeFormField.map((item) {
                  return DropdownMenuItem(
                    value: item['code'],
                    child: Text(item['title']!),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _subStatValueOne = value ?? 'HPP';
                  });
                },
              ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: '부옵1 포인트'),
                initialValue: _subStatPointOne.toString(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a sub option 1 point';
                  } else if (int.tryParse(value) == 0) {
                    return 'Please enter a non-zero sub option 1 point';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (value != null) {
                    _subStatPointOne = int.parse(value);
                  }
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '부옵2'),
                value: _subStatValueTwo,
                items: _statTypeFormField.map((item) {
                  return DropdownMenuItem(
                    value: item['code'],
                    child: Text(item['title']!),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _subStatValueTwo = value ?? 'HPP';
                  });
                },
              ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: '부옵2 포인트'),
                initialValue: _subStatPointTwo.toString(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a sub option 2 point';
                  } else if (int.tryParse(value) == 0) {
                    return 'Please enter a non-zero sub option 2 point';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (value != null) {
                    _subStatPointTwo = int.parse(value);
                  }
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '부옵3'),
                value: _subStatValueThree,
                items: _statTypeFormField.map((item) {
                  return DropdownMenuItem(
                    value: item['code'],
                    child: Text(item['title']!),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _subStatValueThree = value ?? 'HPP';
                  });
                },
              ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: '부옵3 포인트'),
                initialValue: _subStatPointThree.toString(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a sub option 3 point';
                  } else if (int.tryParse(value) == 0) {
                    return 'Please enter a non-zero sub option 3 point';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (value != null) {
                    _subStatPointThree = int.parse(value);
                  }
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '부옵4'),
                value: _subStatValueFour,
                items: _statTypeFormField.map((item) {
                  return DropdownMenuItem(
                    value: item['code'],
                    child: Text(item['title']!),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _subStatValueFour = value ?? 'HPP';
                  });
                },
              ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: '부옵4 포인트'),
                initialValue: _subStatPointFour.toString(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a sub option 4 point';
                  } else if (int.tryParse(value) == 0) {
                    return 'Please enter a non-zero sub option 4 point';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (value != null) {
                    _subStatPointFour = int.parse(value);
                  }
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '변환 여부'),
                value: _convertedFormValue,
                items: _convertedField.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _convertedFormValue = value ?? '없음';
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('저장'),
        ),
      ],
    );
  }
}
