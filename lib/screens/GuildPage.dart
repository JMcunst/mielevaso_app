import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuildPage extends StatefulWidget {
  final String title;

  const GuildPage({Key? key, required this.title}) : super(key: key);

  @override
  _GuildPageState createState() => _GuildPageState();
}

class _GuildPageState extends State<GuildPage> {
  List<String> requesterKeys = [];
  bool isLoading = false;
  String _ourGuildRank = '';
  String _TargetGuildName = '';
  String _TargetGuildRank = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('requester')
            .doc('미엘레바소')
            .get();

    setState(() {
      requesterKeys = List<String>.from(snapshot.data()!.keys);
      isLoading = false;
    });
  }

  void addMember(String requesterKey) {
    FirebaseFirestore.instance.collection('guild').doc('미엘레바소').update({
      'members.$requesterKey': {'nickname': requesterKey, 'rank': '70'}
    });
  }

  Future<void> _enterRequester(String requesterKey) async {
    addMember(requesterKey);
    await _cancelRequester(requesterKey);
    // TODO: 체크된 requester 처리 로직 추가
  }

  Future<void> _showConfirmDialog(
      BuildContext context, String requesterKey) async {
    final isConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('정말로 수락하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('예'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (isConfirmed == true) {
      await _enterRequester(requesterKey);
    }
  }

  Future<void> _cancelRequester(String requesterKey) async {
    final CollectionReference requesterCollection =
        FirebaseFirestore.instance.collection('requester');

    await requesterCollection.doc('미엘레바소').update({
      requesterKey: FieldValue.delete(),
    });
  }

  Future<void> _showCancelDialog(
      BuildContext context, String requesterKey) async {
    final isConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('정말로 취소하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('예'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (isConfirmed == true) {
      await _cancelRequester(requesterKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guild Page'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: Column(
              children: [
                SizedBox(height: 16.0),
                CircleAvatar(
                  radius: 40.0,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Add Your Guild War'),
                            content: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Our Guild Rank'),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your guild rank';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        _ourGuildRank = value ?? '';
                                      },
                                    ),
                                    TextFormField(
                                      decoration:
                                      const InputDecoration(labelText: 'Target Guild Name'),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a target guild name';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        _TargetGuildName = value ?? '';
                                      },
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Target Guild Rank'),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a target guild rank';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        _TargetGuildRank = value ?? '';
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // save form values to database or perform any other desired action
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('ADD'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Please write your war',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.group),
              title: Text('공덱 찾기'),
              subtitle: Text('Level 25'),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.group),
              title: Text('Guild Member 3'),
              subtitle: Text('Level 20'),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Requesters',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                isLoading
                    ? CircularProgressIndicator()
                    : requesterKeys.isEmpty
                        ? Text('No data available')
                        : Container(
                            height: 200,
                            child: ListView.builder(
                              shrinkWrap: false,
                              // itemExtent: 30, // 요소 높이를 50으로 설정
                              itemCount: requesterKeys.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: 70, // 세로 크기를 70으로 조정
                                  child: Card(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(requesterKeys[index]),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.check),
                                            onPressed: () {
                                              _showConfirmDialog(context,
                                                  requesterKeys[index]);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              _showCancelDialog(context,
                                                  requesterKeys[index]);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
