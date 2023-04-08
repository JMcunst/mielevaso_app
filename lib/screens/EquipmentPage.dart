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

  final _categoryFormField = ['sword', 'helmet', 'armor', 'necklace', 'ring', 'shoes'];
  String _categoryValue ='';
  final _convertedField = ['없음', 0, 1, 2, 3];
  String _convertedFormValue ='';
  final _gradeFormField = ['전설', '영웅', '희귀', '일반'];
  String _gradeValue ='';
  final _isBalcksmithFormField = ['가능', '불가능', '제련됨'];
  String _isBalcksmithValue ='';
  int _level = 0;
  final _statTypeFormField = [{'code': 'HPP', 'title': '생명력'},{'code': 'HPS', 'title': '생명력(%)'},
    {'code': 'DFP', 'title': '방어력'}, {'code': 'DFS', 'title': '방어력(%)'},
    {'code': 'ATP', 'title': '공격력'}, {'code': 'ATS', 'title': '공격력(%)'},
    {'code': 'CHC', 'title': '치명확률'}, {'code': 'CHD', 'title': '치명피해'},
    {'code': 'EFV', 'title': '효과적중'}, {'code': 'EFR', 'title': '효과저항'},
    {'code': 'SPD', 'title': '속도'}];
  int _mainStatPoint = 0;
  int _subStatPointOne = 0;
  int _subStatPointTwo = 0;
  int _subStatPointThree = 0;
  int _subStatPointFour = 0;
  String _name = '';
  final _reinforced = 15;
  final _setTypeFormField = [{'code': 'ATK', 'title': '공격'},{'code': 'DEF', 'title': '방어'},
    {'code': 'HLP', 'title': '생명'}, {'code': 'SPD', 'title': '속도'},
    {'code': 'CTR', 'title': '치확'}, {'code': 'DES', 'title': '파멸'},
    {'code': 'HTR', 'title': '적중'}, {'code': 'RES', 'title': '저항'},
    {'code': 'LFS', 'title': '흡혈'}, {'code': 'CNT', 'title': '반격'},
    {'code': 'DUA', 'title': '협공'}, {'code': 'IMM', 'title': '면역'},
    {'code': 'RAG', 'title': '분노'}, {'code': 'PEN', 'title': '관통'},
    {'code': 'REV', 'title': '복수'}, {'code': 'INJ', 'title': '상처'},
    {'code': 'TOR', 'title': '격류'}, {'code': 'PRO', 'title': '수호'}];
  String _setType = '';


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    user = FirebaseAuth.instance.currentUser!;
    allList = [];
    swordList = [];
    helmetList = [];
    armorList = [];
    necklaceList = [];
    ringList = [];
    shoesList = [];
    _loadEquipments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEquipments() async {
    final equipmentsSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .get();
    final testData = [equipmentsSnapshot.data()];
    print('TTTTT:$testData');
    if (equipmentsSnapshot.exists) {
      setState(() {
        swordList = List<Map<String, dynamic>>.from(
            equipmentsSnapshot.data()!['sword'] ?? []);
        helmetList = List<Map<String, dynamic>>.from(
            equipmentsSnapshot.data()!['helmet'] ?? []);
        armorList = List<Map<String, dynamic>>.from(
            equipmentsSnapshot.data()!['armor'] ?? []);
        necklaceList = List<Map<String, dynamic>>.from(
            equipmentsSnapshot.data()!['necklace'] ?? []);
        ringList = List<Map<String, dynamic>>.from(
            equipmentsSnapshot.data()!['ring'] ?? []);
        shoesList = List<Map<String, dynamic>>.from(
            equipmentsSnapshot.data()!['shoes'] ?? []);
        allList = [
          ...swordList,
          ...helmetList,
          ...armorList,
          ...necklaceList,
          ...ringList,
          ...shoesList,
        ];
      });
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
                content: Form(
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
                        decoration: const InputDecoration(
                            labelText: '이름'),
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
                        decoration: const InputDecoration(
                            labelText: '강화'),
                        initialValue: _reinforced.toString(),
                        enabled: false,
                      ),
                      DropdownButtonFormField(
                        decoration:
                        const InputDecoration(labelText: 'Grade'),
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
                        decoration: const InputDecoration(
                            labelText: '레벨'),
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
                        decoration: const InputDecoration(labelText: 'Set'),
                        value: _setType,
                        items: _setTypeFormField.map((Map<String, String> map) {
                          return DropdownMenuItem<String>(
                            value: map['code'],
                            child: Text(map['title']!),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _setType = value ?? '';
                          });
                        },
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('저장'),
                    onPressed: () {
                      // 사용자가 입력한 데이터 출력
                      Navigator.of(context).pop();
                    },
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
