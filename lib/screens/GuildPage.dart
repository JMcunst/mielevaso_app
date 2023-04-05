import 'dart:async';
import 'dart:developer';

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
    log('T11111');

    setState(() {
      requesterKeys = List<String>.from(snapshot.data()!.keys);
      isLoading = false;
    });
  }

  void addMember(String requesterKey) {
    FirebaseFirestore.instance
        .collection('guild')
        .doc('미엘레바소')
        .update({
      'members.$requesterKey': {
        'nickname': requesterKey,
        'rank': '70'
      }
    });
  }

  Future<void> _enterRequester(String requesterKey) async {
    addMember(requesterKey);
    await _cancelRequester(requesterKey);
    // TODO: 체크된 requester 처리 로직 추가
  }

  Future<void> _showConfirmDialog(BuildContext context, String requesterKey) async {
    log('SSSS:$context');
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
    final CollectionReference requesterCollection = FirebaseFirestore.instance.collection('requester');

    await requesterCollection.doc('미엘레바소').update({
      requesterKey: FieldValue.delete(),
    });
  }

  Future<void> _showCancelDialog(BuildContext context, String requesterKey) async {
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
            child: ListTile(
              leading: Icon(Icons.group),
              title: Text('Guild Member 1'),
              subtitle: Text('Level 30'),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.group),
              title: Text('Guild Member 2'),
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
              children: <Widget>[
                Text(
                  'Requesters',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
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
                                    _showConfirmDialog(context, requesterKeys[index]);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    _showCancelDialog(context, requesterKeys[index]);
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
