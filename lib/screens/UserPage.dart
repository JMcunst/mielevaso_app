import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../apis/google_auth_api.dart';
import '../secrets/email.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _nickname = '';
  String _rank = '';
  String _server = '한국';
  String _guildName = '';
  String _guildPosition = '단원';
  String _arena = 'hidden';
  String _selena = 'hidden';
  List<String> _arenaFields = [];
  List<String> _realArenaFields = [];
  List<String> _guildNameFields = [];
  final List<String> _guildPositionFields = ['단장', '부단장', '단원'];
  final List<String> _serverFields = ['한국', '아시아', '글로벌', '유럽', '일본'];

  final _mailFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _serverController = TextEditingController();
  final _guildNameController = TextEditingController();
  final _commentController = TextEditingController();

  bool _isUpdate = false;
  late String _docId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getArenas();
    _getRealArenas();
    _getGuildName();
    _checkUser();
  }

  void _checkUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();

    if (userData.exists &&
        userData['nickname'] != null &&
        userData['server'] != null) {
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
    tiers.sort(
        (a, b) => arenaData[a]['min_pt'].compareTo(arenaData[b]['min_pt']));

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
    tiers.sort((a, b) =>
        realArenaData[a]['min_pt'].compareTo(realArenaData[b]['min_pt']));

    setState(() {
      _realArenaFields = tiers;
    });
  }

  void _getGuildName() async {
    final guildNameDocs = await FirebaseFirestore.instance
        .collection('guild')
        .get();

    List<String> guildNames = guildNameDocs.docs.map((doc) => doc.id).toList();
    guildNames.sort();
    guildNames.insert(0, '없음');
    // var firstGuildName = guildNames[0].runtimeType;
    log('EEEEE:$guildNames');

    setState(() {
      _guildNameFields = guildNames;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Firebase에 값을 저장
      final user = FirebaseAuth.instance.currentUser;
      final scaffoldContext = _formKey.currentContext; // 변경된 부분
      if (_isUpdate) {
        await FirebaseFirestore.instance.collection('user').doc(_docId).update({
          'nickname': _nickname,
          'rank': _rank,
          'server': _server,
          'guildName': _guildName,
          'guildPosition': _guildPosition,
          'arena': _arena,
          'selena': _selena,
        });
        if (scaffoldContext != null) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
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
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text('성공적으로 생성 되었습니다.'),
            ),
          );
        }
      }

      // 다이얼로그 닫기
      Navigator.of(scaffoldContext!).pop();
    }
  }

  Future<void> _submitMailForm() async {
    if (_mailFormKey.currentState!.validate()) {
      // Email the form data
      final user = await GoogleAuthApi.signIn();
      if (user==null) return;
      final email = user.email;
      final auth = await user.authentication;
      final token = auth.accessToken!;

      final name = _nameController.text;
      final server = _serverController.text;
      final guildName = _guildNameController.text;
      final comment = _commentController.text;

      // final smtpServer = gmail('no.reply.ezcominc@gmail.com', GMAIL_PASSWORD_NEW);
      // final smtpServer = gmailRelaySaslXoauth2('no.reply.ezcominc@gmail.com', token);
      final smtpServer = gmailSaslXoauth2('no.reply.ezcominc@gmail.com', token);
      // log('PWDPWDPWDPWD:$GMAIL_PASSWORD_NEW');
      final message = Message()
        ..from = Address('no.reply.ezcominc@gmail.com', 'Jmcunst')
        ..recipients.add('xnslqjtmghaf@gmail.com')
        ..subject = 'Please Enroll my Guild'
        ..text = 'Name: $name\nServer: $server\nGuild Name: $guildName\nComment: $comment';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ${sendReport.toString()}');
      } on MailerException catch (e) {
        print('Message not sent: ${e.toString()}');
      }
    }
  }

  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }

  void itemSelectionChanged(String? s) {
    print(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_isUpdate ? 'Update Form' : 'User Information'),
        ),
        body: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          Text(_isUpdate ? 'Update Form' : 'User Information'),
                      content: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Nickname'),
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
                                decoration:
                                    const InputDecoration(labelText: 'Rank'),
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
                              DropdownButtonFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Server'),
                                value: _server,
                                items: _serverFields.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _server = value ?? '';
                                  });
                                },
                              ),
                              DropdownSearch<String>(
                                mode: Mode.MENU,
                                showSelectedItems: true,
                                items: _guildNameFields,
                                dropdownSearchDecoration: const InputDecoration(
                                  labelText: "Select Guild Name",
                                  hintText: "search your guild name",
                                ),
                                popupItemDisabled: isItemDisabled,
                                onChanged: itemSelectionChanged,
                                //selectedItem: "",
                                showSearchBox: true,
                                searchFieldProps: const TextFieldProps(
                                  cursorColor: Colors.blue,
                                ),
                              ),
                              DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Guild Position'),
                                value: _guildPosition,
                                items: _guildPositionFields.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _guildPosition = value ?? '';
                                  });
                                },
                              ),
                              DropdownButtonFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Arena'),
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
                                decoration: const InputDecoration(
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
                          child: const Text('CANCEL'),
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
          Center(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('User Information'),
                      content: SingleChildScrollView(
                        child: Form(
                          key: _mailFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(labelText: 'Name'),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _serverController,
                                decoration: const InputDecoration(labelText: 'Server'),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a server';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _guildNameController,
                                decoration: const InputDecoration(labelText: 'Guild Name'),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a guild name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _commentController,
                                decoration: const InputDecoration(labelText: 'Comment'),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a comment';
                                  }
                                  return null;
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
                          child: const Text('CANCEL'),
                        ),
                        ElevatedButton(
                          onPressed: _submitMailForm,
                          child: const Text('SUBMIT'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Enter Information'),
            ),
          ),
        ]));
  }
}
