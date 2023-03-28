import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _nickname = '';
  String _rank = '';
  String _server = '';
  String _guildName = '';
  String _guildPosition = '';
  String _arena = 'hidden';
  String _selena = 'hidden';
  List<String> _arenaFields = [];
  List<String> _realArenaFields = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isUpdate = false;
  late String _docId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getArenas();
    _getRealArenas();
    _checkUser();
  }

  void _checkUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();

    if (userData.exists && userData['nickname'] != null && userData['server'] != null) {
      setState(() {
        _isUpdate = true;
        _docId = userData.id;
        _nickname = userData['nickname'];
        _rank = userData['rank'];
        _server = userData['server'];
        _guildName = userData['guildName'];
        _guildPosition = userData['guildPosition'];
        _arena = userData['arena'];
        _selena = userData['selena'];
      });
    } else {
      setState(() {
        _isUpdate = false;
      });
    }
  }

  void _getArenas() async {
    final arenaDocs = await FirebaseFirestore.instance
        .collection('gv_tiers')
        .doc('arena')
        .get();
    final arenaData = arenaDocs.data() as Map<String, dynamic>;
    List<String> tiers = arenaData.keys.toList();
    tiers.sort((a, b) => arenaData[a]['min_pt'].compareTo(arenaData[b]['min_pt']));

    setState(() {
      _arenaFields = tiers;
    });
  }

  void _getRealArenas() async {
    final realArenaDocs = await FirebaseFirestore.instance
        .collection('gv_tiers')
        .doc('real_arena')
        .get();
    final realArenaData = realArenaDocs.data() as Map<String, dynamic>;
    List<String> tiers = realArenaData.keys.toList();
    tiers.sort((a, b) => realArenaData[a]['min_pt'].compareTo(realArenaData[b]['min_pt']));

    setState(() {
      _realArenaFields = tiers;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Firebase에 값을 저장
      final user = FirebaseAuth.instance.currentUser;
      final scaffoldContext = scaffoldKey.currentContext; // 변경된 부분
      if (_isUpdate) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(_docId)
            .update({
          'nickname': _nickname,
          'rank': _rank,
          'server': _server,
          'guildName': _guildName,
          'guildPosition': _guildPosition,
          'arena': _arena,
          'selena': _selena,
        });
        if (scaffoldContext != null) {
          ScaffoldMessenger.of(scaffoldContext!).showSnackBar(
            SnackBar(
              content: Text('성공적으로 업데이트 되었습니다.'),
            ),
          );
        }
      } else {
        await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
          'nickname': _nickname,
          'rank': _rank,
          'server': _server,
          'guildName': _guildName,
          'guildPosition': _guildPosition,
          'arena': _arena,
          'selena': _selena,
        });
        if (scaffoldContext != null) {
          ScaffoldMessenger.of(scaffoldContext!).showSnackBar(
            SnackBar(
              content: Text('성공적으로 생성 되었습니다.'),
            ),
          );
        }
      }

      // 다이얼로그 닫기
      Navigator.of(scaffoldContext!).pop();
    }
  }

  void _resetForm() {
    setState(() {
      _nickname = '';
      _rank = '';
      _server = '';
      _guildName = '';
      _guildPosition = '';
      _arena = '';
      _selena = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdate ? 'Update Form' : 'User Information'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(_isUpdate ? 'Update Form' : 'User Information'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Nickname'),
                            initialValue: _nickname,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a nickname';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _nickname = value ?? '';
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Rank'),
                            initialValue: _rank,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a rank';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _rank = value ?? '';
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Server'),
                            initialValue: _server,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a server';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _server = value ?? '';
                            },
                          ),
                          TextFormField(
                            decoration:
                            InputDecoration(labelText: 'Guild Name'),
                            initialValue: _guildName,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a guild name';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _guildName = value ?? '';
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Guild Position (if applicable)'),
                            initialValue: _guildPosition,
                            onSaved: (String? value) {
                              _guildPosition = value ?? '';
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: 'Arena'),
                            value: _arena,
                            items: _arenaFields.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _arena = value ?? '';
                              });
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelText: 'Real Arena'),
                            value: _selena,
                            items: _realArenaFields.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selena = value ?? '';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('CANCEL'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(_isUpdate ? 'Update' : 'Submit'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text(_isUpdate ? 'Update Form' : 'Enter Information'),
        ),
      ),
    );
  }
}
