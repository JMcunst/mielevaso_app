import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({Key? key}) : super(key: key);

  @override
  _EquipmentPageState createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late User user;
  late List<Map<String, dynamic>> allList;
  late List<Map<String, dynamic>> swordList;
  late List<Map<String, dynamic>> helmetList;
  late List<Map<String, dynamic>> armorList;
  late List<Map<String, dynamic>> necklaceList;
  late List<Map<String, dynamic>> ringList;
  late List<Map<String, dynamic>> shoesList;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _categoryFormField = [
    'sword',
    'helmet',
    'armor',
    'necklace',
    'ring',
    'shoes'
  ];
  String _categoryValue = 'sword';
  final List<String> _convertedField = ['없음', '1번째', '2번째', '3번째', '4번째'];
  String _convertedFormValue = '없음';
  final List<String> _gradeFormField = ['전설', '영웅', '희귀', '일반'];
  String _gradeValue = '전설';
  final List<String> _isBalcksmithFormField = ['가능', '불가능', '제련됨'];
  String _isBalcksmithValue = '불가능';
  int _level = 0;
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
  String _subStatValueOne = 'HPP';
  int _subStatPointTwo = 0;
  String _subStatValueTwo = 'HPP';
  int _subStatPointThree = 0;
  String _subStatValueThree = 'HPP';
  int _subStatPointFour = 0;
  String _subStatValueFour = 'HPP';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(_onTabSelected);
    user = FirebaseAuth.instance.currentUser!;
    allList = [];
    swordList = [];
    helmetList = [];
    armorList = [];
    necklaceList = [];
    ringList = [];
    shoesList = [];
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Future<void> _loadAll() async {
    await _loadSwords();
    await _loadArmors();
    await _loadHelmets();
    await _loadNecklaces();
    await _loadRings();
    await _loadShoes();
    setState(() {
      allList = [
        ...swordList,
        ...armorList,
        ...helmetList,
        ...necklaceList,
        ...ringList,
        ...shoesList,
      ];
    });
  }
  Future<List<Map<String, dynamic>>> _loadSwords() async {
    final swordsSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('swords')
        .doc('sword')
        .get();
    if (swordsSnapshot.exists) {
      return List<Map<String, dynamic>>.from(swordsSnapshot.data()!['swords'] ?? []);
    }
    return [];
  }
  Future<List<Map<String, dynamic>>> _loadArmors() async {
    final armorsSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('armors')
        .doc('armor')
        .get();
    if (armorsSnapshot.exists) {
      return List<Map<String, dynamic>>.from(armorsSnapshot.data()!['armors'] ?? []);
    }
    return [];}
  Future<List<Map<String, dynamic>>> _loadHelmets() async {
    final helmetsSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('helmets')
        .doc('helmet')
        .get();
    if (helmetsSnapshot.exists) {
      return List<Map<String, dynamic>>.from(helmetsSnapshot.data()!['helmets'] ?? []);
    }
    return [];}
  Future<List<Map<String, dynamic>>> _loadNecklaces() async {
    final necklacesSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('necklaces')
        .doc('necklace')
        .get();
    if (necklacesSnapshot.exists) {
      return List<Map<String, dynamic>>.from(necklacesSnapshot.data()!['necklaces'] ?? []);
    }
    return [];}
  Future<List<Map<String, dynamic>>> _loadRings() async {
    final ringsSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('rings')
        .doc('ring')
        .get();
    if (ringsSnapshot.exists) {
      return List<Map<String, dynamic>>.from(ringsSnapshot.data()!['rings'] ?? []);
    }
    return [];}
  Future<List<Map<String, dynamic>>> _loadShoes() async {
    final shoesSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('shoes')
        .doc('shoe')
        .get();
    if (shoesSnapshot.exists) {
      return List<Map<String, dynamic>>.from(shoesSnapshot.data()!['shoes'] ?? []);
    }
    return [];
  }



  double calEquipmentScore(){
    double score = 0.0;

    // TODO: GET SCORE LOGIC
    return score;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Firebase에 값을 저장
      final user = FirebaseAuth.instance.currentUser;
      final scaffoldContext = _formKey.currentContext; // 변경된 부분

      double score_equipment = calEquipmentScore();
      final setData = {
        "name": _name,
        "level":_level,
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
        "status":true,
        "created_at":FieldValue.serverTimestamp(),
        "update_at":FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('equipment').doc(user!.uid).collection(_categoryValue+'s').doc(_categoryValue).set(setData);
      if (scaffoldContext != null) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            content: Text('성공적으로 생성 되었습니다.'),
          ),
        );
      }


      // 다이얼로그 닫기
      Navigator.of(scaffoldContext!).pop();
    }
  }

  void _onTabSelected() {
    switch (_tabController.index) {
      case 0:
        _loadAll();
        break;
      case 1:
        _loadSwords().then((swords) {
          setState(() {
            swordList = swords;
          });
        });
        break;
      case 2:
        _loadHelmets().then((helmets) {
          setState(() {
            helmetList = helmets;
          });
        });
        break;
      case 3:
        _loadArmors().then((armors) {
          setState(() {
            armorList = armors;
          });
        });
        break;
      case 4:
        _loadNecklaces().then((necklaces) {
          setState(() {
            necklaceList = necklaces;
          });
        });
        break;
      case 5:
        _loadRings().then((rings) {
          setState(() {
            ringList = rings;
          });
        });
        break;
      case 6:
        _loadShoes().then((shoes) {
          setState(() {
            shoesList = shoes;
          });
        });
        break;
    }
  }

  Widget _buildTabView(List<Map<String, dynamic>> equipments) {
    return ListView.builder(
      itemCount: equipments.length,
      itemBuilder: (context, index) {
        final equipment = equipments[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/main.png',
                  width: 64,
                  height: 64,
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(equipment['name']),
                    SizedBox(height: 4.0),
                    Text(equipment['set'].replaceAll('SET_', '')),
                    SizedBox(width: 8.0),
                    Text(equipment['grade']),
                  ],
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('장비 점수'),
                    SizedBox(width: 8.0),
                    Text(
                      equipment['score'].toStringAsFixed(1),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장비 목록'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(
              icon: ImageIcon(
                AssetImage("assets/icons/all.png"),
                size: 24,
              ),
            ),
            Tab(
              icon: ImageIcon(
                AssetImage("assets/icons/sword.png"),
                size: 24,
              ),

            ),
            Tab(
              icon: ImageIcon(
                AssetImage("assets/icons/helmet.png"),
                size: 24,
              ),
            ),
            Tab(
              icon: ImageIcon(
                AssetImage("assets/icons/armor.png"),
                size: 24,
              ),
            ),
            Tab(
              icon: ImageIcon(
                AssetImage("assets/icons/necklace.png"),
                size: 24,
              ),
            ),
            Tab(
              icon: ImageIcon(
                AssetImage("assets/icons/ring.png"),
                size: 24,
              ),
            ),
            Tab(
              icon: ImageIcon(
                AssetImage("assets/icons/shoes.png"),
                size: 24,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabView(allList),
          _buildTabView(swordList),
          _buildTabView(helmetList),
          _buildTabView(armorList),
          _buildTabView(necklaceList),
          _buildTabView(ringList),
          _buildTabView(shoesList),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialog 띄우기
          showDialog(
            context: context,
            builder: (BuildContext context) {
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
                              _categoryValue = value ?? '';
                            });
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: '이름'),
                          initialValue: _name,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter item name';
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            _name = value ?? '';
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
                              _gradeValue = value ?? '';
                            });
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: '레벨'),
                          initialValue: _level.toString(),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a level';
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            if (value != null) {
                              _level = int.parse(value);
                            }
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
            },
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
