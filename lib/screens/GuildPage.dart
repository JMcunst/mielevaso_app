import 'package:flutter/material.dart';

class GuildPage extends StatefulWidget {
  const GuildPage({Key? key}) : super(key: key);

  @override
  State<GuildPage> createState() => _GuildPageState();
}

class _GuildPageState extends State<GuildPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Guild Page'),
    );
  }
}
