import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mielevaso_app/screens/user_pvp_page.dart';
import 'package:mielevaso_app/widgets/user_info_widget.dart';

import 'UserFormDialog.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UserFormDialog();
                },
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: w,
                height: h * 0.21,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/main.png"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.1,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 40,
                      backgroundImage: AssetImage("assets/images/main.png"),
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "꿀몽이",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "미엘레바소",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          " / ",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          "단장",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            UserPvpPage(),
            UserInfoWidget()
          ],
        ),
      ),
    );
  }
}
