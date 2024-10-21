import 'package:flutter/material.dart';
import 'package:inco/service/bannerScrvice.dart';

class TestScren extends StatelessWidget {
  const TestScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                print('object');
                BannerService bannerService = BannerService();
                bannerService.showNotification('title', 'body');
              },
              child: const Text('data'))),
    );
  }
}
