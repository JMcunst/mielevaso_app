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
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('장비 개수'),
                      Text('111/500')
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('아레나'),
                      Image(image: AssetImage("assets/images/main.png")),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('실레나'),
                      Image(image: AssetImage("assets/images/main.png")),
                    ],
                  )
                ],
              ),
            ),
            // GridView.count(
            //   crossAxisCount: 3,
            //   childAspectRatio: 1, // 가로 세로 비율을 1:1로 설정
            //   mainAxisSpacing: 0, // 수직 방향 간격을 0으로 설정
            //   crossAxisSpacing: 0,
            //   shrinkWrap: true,
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.black, width: 1),
            //         color: Colors.blue,
            //       ),
            //       child: Text('장비 개수'),
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.black, width: 1),
            //         color: Colors.red,
            //       ),
            //       child: Text('아레나'),
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.black, width: 1),
            //         color: Colors.green,
            //       ),
            //       child: Text('실레나'),
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.black, width: 1),
            //         color: Colors.yellow,
            //       ),
            //       child: Text('111/500'),
            //     ),
            //     Container(
            //       width: 30,
            //       height: 30,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.black, width: 1),
            //         color: Colors.orange,
            //       ),
            //       child: Image(
            //         image: AssetImage("assets/images/main.png"),
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //     Container(
            //       width: 30,
            //       height: 30,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.black, width: 1),
            //         color: Colors.purple,
            //       ),
            //       child: Image(
            //         image: AssetImage("assets/images/main.png"),
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ].map((child) => Center(child: child)).toList(),
            // ),
            UserInfoWidget()
          ],
        ),
      ),
    );
  }
}
