import 'package:flutter/cupertino.dart';

import '../utils/custom_colors.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 428,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: CustomColors.dividerLine.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 30,
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(bottom: 10.0, left: 8.0, top: 6.0),
            child: const Text(
              "User Setting",
              style: TextStyle(
                color: CustomColors.textColorBlack,
                fontSize: 17.0,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      child: Text(
                        "testtest",
                        style: TextStyle(
                          color: CustomColors.textColorBlack,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset("assets/icons/all.png"),
                    ),
                    Text("°")
                  ],
                ),
              ),
              Container(
                height: 1,
                color: CustomColors.dividerLine.withAlpha(255),
              )
            ],
          )
        ],
      ),
    );
  }
}
