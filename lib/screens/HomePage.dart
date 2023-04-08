import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mielevaso_app/screens/EquipmentPage.dart';
import 'package:mielevaso_app/screens/GuildNotFoundPage.dart';
import 'package:mielevaso_app/screens/GuildPage.dart';
import 'package:mielevaso_app/screens/UserPage.dart';

class HomePage extends StatefulWidget {
  final int initialPageIndex;
  const HomePage({Key? key, this.initialPageIndex = 0}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const GuildPage(title: 'my-guild'),
    const EquipmentPage(),
    const UserPage(title: 'UserPage'),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getGuildName(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          final guildName = snapshot.data;
          if(_currentIndex >= 1){
            body = _children[_currentIndex];
          }else if(guildName == '없음'){
            body = const GuildNotFoundPage();
          }else{
            body = _children[_currentIndex];
          }
        } else if (snapshot.hasError) {
          body = const Center(child: Text('Error!'));
        } else {
          body = const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Guild',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grading),
                label: 'Equipment',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'User',
              ),
            ],
          ),
        );
      },
    );
  }


  Future<String?> _getGuildName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
      return snapshot.data()?['guildName'];
    }
    return null;
  }
}
