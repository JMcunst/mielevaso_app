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
  String _arena = '';
  String _selena = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Firebase에 값을 저장
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
        'nickname': _nickname,
        'rank': _rank,
        'server': _server,
        'guildName': _guildName,
        'guildPosition': _guildPosition,
        'arena': _arena,
        'selena': _selena,
      });

      // 다이얼로그 닫기
      Navigator.of(context).pop();
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
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('User Information'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Nickname'),
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
                            decoration:
                                InputDecoration(labelText: 'Guild Position'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a guild position';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _guildPosition = value ?? '';
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Arena'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an arena';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _arena = value ?? '';
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Selena'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Selena';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _selena = value ?? '';
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _resetForm();
                                },
                                child: Text('Reset'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState!.save();
                                  _submitForm();
                                },
                                child: Text('Submit'),
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
          },
          child: Text('Open Form'),
        ),
      ),
    );
  }
}
