import 'package:creative_mobile/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HMPage extends StatefulWidget {
  const HMPage({super.key});

  @override
  State<HMPage> createState() => _HMPageState();
}

class _HMPageState extends State<HMPage> {
  _removePF() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final _user_id = pref.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text("Update HM"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: (() {
                _removePF();
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
