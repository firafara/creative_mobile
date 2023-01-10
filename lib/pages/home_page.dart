import 'package:creative_mobile/services/api_service.dart';
import 'package:creative_mobile/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? _token = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    _LoadPF();
  }

  _LoadPF() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _token = (pref.getInt('userId') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("CREATIVE"),
        elevation: 0,
        actions: [
          Container(
            height: size.height * .9,
            decoration: BoxDecoration(
                image: DecorationImage(
                    // alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/background-blue.png'))),
          ),
          IconButton(
              onPressed: (() {
                SharedService.logout(context);
              }),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: Colors.blue[100],
      body: Stack(
        children: [
          Container(
            height: size.height * .9,
            decoration: BoxDecoration(
                image: DecorationImage(
                    // alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/background-blue.png'))),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    height: 64,
                    margin: EdgeInsets.only(left: 5, bottom: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 100,
                      crossAxisSpacing: 10,
                      primary: false,
                      // ignore: sort_child_properties_last
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListTile(
                                title: Image.asset(
                                  "assets/icons/hm.png",
                                  height: 80,
                                  width: 80,
                                ),
                                subtitle: Container(
                                  margin: EdgeInsets.only(left: 5, top: 25),
                                  child: Center(
                                    child: Text(
                                      "Service Report",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      '/service-report', (route) => false);
                                },
                              ),
                            ],
                          ),
                        ),
                        Card(
                          // color: Colors.yellow[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListTile(
                                title: Image.asset(
                                  "assets/icons/service.png",
                                  height: 80,
                                  width: 80,
                                ),
                                subtitle: Center(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5, top: 25),
                                    child: Text(
                                      "Update HM",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/update-hm', (route) => false);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      crossAxisCount: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
