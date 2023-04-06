import 'package:cloud_firestore/cloud_firestore.dart';

import 'HomePage.dart';
import 'RegisterPage.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(); //입력되는 값을 제어
  final TextEditingController _passwordController = TextEditingController();

  String _imageFile = 'assets/images/main.png';

  Widget _userIdWidget() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '이메일',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          // == null or isEmpty
          return '이메일을 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _passwordWidget() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          // == null or isEmpty
          return '비밀번호를 입력해주세요.';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("로그인"),
        centerTitle: true,
      ),
      body: GestureDetector(
        // 변경된 부분: GestureDetector 추가
        onTap: () {
          // 키보드 숨기기
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image(
                    width: 400.0, height: 250.0, image: AssetImage(_imageFile)),
                const SizedBox(height: 20.0),
                _userIdWidget(),
                const SizedBox(height: 20.0),
                _passwordWidget(),
                Container(
                  height: 70,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                      onPressed: () => _login(), child: const Text("로그인")),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  child: const Text('회원 가입'),
                  onTap: () {
                    Get.to(() => const RegisterPage());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();
  }

  @override
  void dispose() {
    // 해당 클래스가 사라질떄
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _login() async {
    if (_formKey.currentState!.validate()) {
      // 키보드 숨기기
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        currentFocus.focusedChild?.unfocus();
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (userCredential.user != null) {
          // 로그인 성공
          Get.offAll(() => const HomePage());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // 이메일이나 비밀번호가 잘못됨
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('이메일이나 비밀번호가 잘못되었습니다.'),
            ),
          );
        } else if (e.code == 'wrong-password') {
          // 이메일이나 비밀번호가 잘못됨
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('이메일이나 비밀번호가 잘못되었습니다.'),
            ),
          );
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

}
