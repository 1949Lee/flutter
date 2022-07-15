import 'package:flutter/cupertino.dart';


class ProfileTab extends StatelessWidget {
  static const title = '我的';
  static const icon = Icon(CupertinoIcons.profile_circled);

  const ProfileTab({super.key});

  @override
  Widget build(context) {
    return const Text('我的页面');
  }
}
