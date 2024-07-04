import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalScreen extends StatelessWidget {
  const LocalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, World').tr(),
      ),
      body: Center(
        child: Column(
          children: [
            Text('login').tr(),
            Text('signup').tr(),
          ],
        ),
      ),
    );
  }
}
