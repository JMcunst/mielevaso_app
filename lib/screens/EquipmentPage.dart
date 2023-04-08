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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          onTap: (index) {
            switch (index) {
              case 0:
                _tabController.animateTo(0);
                break;
              case 1:
                _tabController.animateTo(1);
                _buildEquipmentList('sword');
                break;
              case 2:
                _tabController.animateTo(2);
                _buildEquipmentList('helmet');
                break;
              case 3:
                _tabController.animateTo(3);
                _buildEquipmentList('armor');
                break;
              case 4:
                _tabController.animateTo(4);
                _buildEquipmentList('necklace');
                break;
              case 5:
                _tabController.animateTo(5);
                _buildEquipmentList('ring');
                break;
              case 6:
                _tabController.animateTo(6);
                _buildEquipmentList('shoes');
                break;
              default:
                break;
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEquipmentList('all'),
          _buildEquipmentList('sword'),
          _buildEquipmentList('helmet'),
          _buildEquipmentList('armor'),
          _buildEquipmentList('necklace'),
          _buildEquipmentList('ring'),
          _buildEquipmentList('shoes'),
        ],
      ),
    );
  }

  Widget _buildEquipmentList(String category) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // 사용자가 로그인하지 않았을 경우 로그인 페이지로 이동하거나 알림을 표시할 수 있습니다.
      return Center(
        child: Text('로그인이 필요합니다.'),
      );
    }
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('equipments')
          .doc(user.uid)
          .collection('equipments')
          .where('category', isEqualTo: category == 'all' ? '' : category)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final QuerySnapshot querySnapshot = snapshot.data!;
          final List<DocumentSnapshot> documents = querySnapshot.docs;
          return documents.isEmpty
              ? const Center(
            child: Text('장비가 없습니다.'),
          )
              : ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              final Map<String, dynamic> data =
              documents[index].data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['category']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('삭제 확인'),
                          content: const Text('정말 삭제하시겠습니까?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('취소'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('삭제'),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('equipments')
                                    .doc(user.uid)
                                    .collection('equipments')
                                    .doc(documents[index].id)
                                    .delete();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

}
