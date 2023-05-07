import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EquipmentFormDialog.dart';
import 'EquipmentDetailDialog.dart';

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
      return List<Map<String, dynamic>>.from(
          swordsSnapshot.data()!['datas'] ?? []);
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
      return List<Map<String, dynamic>>.from(
          armorsSnapshot.data()!['datas'] ?? []);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> _loadHelmets() async {
    final helmetsSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('helmets')
        .doc('helmet')
        .get();
    if (helmetsSnapshot.exists) {
      return List<Map<String, dynamic>>.from(
          helmetsSnapshot.data()!['datas'] ?? []);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> _loadNecklaces() async {
    final necklacesSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('necklaces')
        .doc('necklace')
        .get();
    if (necklacesSnapshot.exists) {
      return List<Map<String, dynamic>>.from(
          necklacesSnapshot.data()!['datas'] ?? []);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> _loadRings() async {
    final ringsSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('rings')
        .doc('ring')
        .get();
    if (ringsSnapshot.exists) {
      return List<Map<String, dynamic>>.from(
          ringsSnapshot.data()!['datas'] ?? []);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> _loadShoes() async {
    final shoesSnapshot = await FirebaseFirestore.instance
        .collection('equipments')
        .doc(user.uid)
        .collection('shoes')
        .doc('shoe')
        .get();
    if (shoesSnapshot.exists) {
      return List<Map<String, dynamic>>.from(
          shoesSnapshot.data()!['datas'] ?? []);
    }
    return [];
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
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) =>
                    EquipmentDetailDialog(equipment: equipment),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      equipment['img_url'],
                      width: 64,
                      height: 64,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(equipment['name']),
                        const SizedBox(height: 6.0),
                        Text('세트: ${equipment['set'].replaceAll('SET_', '')}'),
                        const SizedBox(width: 16.0),
                        Text(equipment['grade']),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('장비 점수'),
                      const SizedBox(width: 8.0),
                      Text(
                        equipment['score'].toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
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
        actions: [
          IconButton(
            iconSize: 30,
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const EquipmentFormDialog();
                },
              );
            },
          ),
        ],
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
    );
  }
}
