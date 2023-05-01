import 'package:flutter/cupertino.dart';

import '../utils/app_layout.dart';
import '../utils/custom_colors.dart';

class UserPvpPage extends StatefulWidget {
  const UserPvpPage({Key? key}) : super(key: key);

  @override
  State<UserPvpPage> createState() => _UserPvpPageState();
}

class _UserPvpPageState extends State<UserPvpPage> {
  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return SizedBox(
      width: size.width,
      height: 200,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 0.15*size.width,
                        child: Text('장비 개수', style: Styles.headLineStyle3,),
                      ),
                      Container(
                        width: 0.14*size.width,
                        child: Text('아레나', style: Styles.headLineStyle3,),
                      ),
                      Container(
                        width: 0.14*size.width,
                        child: Text('실레나', style: Styles.headLineStyle3,),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text('111/500', style: Styles.headLineStyle3,),
                      ),
                      Container(
                        child: Image(image: AssetImage("assets/images/main.png")),
                      ),
                      Container(
                        child: Image(image: AssetImage("assets/images/main.png")),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
