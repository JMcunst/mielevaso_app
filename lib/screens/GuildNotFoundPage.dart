import 'package:flutter/material.dart';

class GuildNotFoundPage extends StatelessWidget {
  const GuildNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.group,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Guild not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
