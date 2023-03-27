import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mielevaso_app/screens/GuildPage.dart';

import 'LoginPage.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState(){
    super.initState();

    // _permission();
    _logout();
    _auth();

  }

  @override
  void dispose(){
    super.dispose();
  }

  // 제거해도 되는 부분이나, 추후 권한 설정과 관련된 포스팅 예정
  // _permission() async{
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.storage,
  //   ].request();
  //   //logger.i(statuses[Permission.storage]);
  // }

  _auth(){
    // 사용자 인증정보 확인. 딜레이를 두어 확인
    Future.delayed(const Duration(milliseconds: 100),() {
      if(FirebaseAuth.instance.currentUser == null){
        Get.off(() => const LoginPage());
      } else {
        Get.off(() => const GuildPage());
      }
    });
  }

  _logout() async{
    await FirebaseAuth.instance.signOut();
  }
}