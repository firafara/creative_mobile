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
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
                //pushName berguna untuk memanggil nama route yang telah kita buat di main dart
              },
              label: Text('Back'),
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50),
                ),
              ),
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
