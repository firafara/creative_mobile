import 'package:creative_mobile/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HMPage extends StatefulWidget {
  const HMPage({super.key});

  @override
  State<HMPage> createState() => _HMPageState();
}

class _HMPageState extends State<HMPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Update HM"),
          elevation: 0,
          actions: [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
                //pushName berguna untuk memanggil nama route yang telah kita buat di main dart
              },
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(),
            ),
            IconButton(
              onPressed: (() {
                SharedService.logout(context);
              }),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Container(
          child: Form(
            child: UpdateHMForm(context),
          ),
        ),
      ),
    );
  }

  Widget UpdateHMForm(BuildContext context) {
    return Scaffold();
  }
}
