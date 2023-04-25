import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mielevaso_app/widgets/user_info_widget.dart';

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: w,
              height: h * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/main.png"),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 64),
            Container(
              child: Column(
                children: [
                  Text(
                    "꿀몽이",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "미엘레바소",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    "단장",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 64),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("169/500"),
                  SizedBox(width: 4),
                  Container(
                    child: Column(
                      children: [
                        Text("아레나"),
                        Image(image: AssetImage("assets/images/main.png")),
                      ],
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    child: Column(
                      children: [
                        Text("실레나"),
                        Image(image: AssetImage("assets/images/main.png")),
                      ],
                    ),
                  )
                ],
              ),
            ),
            UserInfoWidget()
          ],
        ),
      ),
    );
  }
}
