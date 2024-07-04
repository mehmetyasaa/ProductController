import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalScreen extends StatelessWidget {
  const LocalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, World').tr(),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('login').tr(),
            const Text('signup').tr(),
          ],
        ),
      ),
    );
  }
}
