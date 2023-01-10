import 'dart:convert';
import 'package:creative_mobile/config.dart';
import 'package:creative_mobile/models/list_spk.dart';
import 'package:creative_mobile/services/shared_service.dart';
import 'package:creative_mobile/services/spkdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final List<String> faulty = [
  'General',
  'Engine',
  'Electric',
  'Transmission',
  'Brake',
  'Steering',
  'Frame & Suspension',
  'Cabin',
  'Hydraulic',
  'Normal Condition'
];

final List<String> serviceStatus = [
  'Waiting For Part',
  'Finished',
  'Open',
];

final List<String> afterService = [
  'Breakdown',
  'Idle',
  'Running',
];

String? selectedValue1;
String? selectedValue2;
String? selectedValue3;
bool light = true;

final _formKey = GlobalKey<FormState>();

class ServiceReportPage extends StatefulWidget {
  const ServiceReportPage({super.key});
  @override
  State<ServiceReportPage> createState() => _ServiceReportPageState();
}

class _ServiceReportPageState extends State<ServiceReportPage> {
  TextEditingController dateInputController = TextEditingController();
  HtmlEditorController analysis = HtmlEditorController();
  HtmlEditorController service_note = HtmlEditorController();
  HtmlEditorController action = HtmlEditorController();
  SpkDBServices svc = SpkDBServices();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
                indicator: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(100),
                ),
                tabs: [
                  Tab(icon: Icon(Icons.maps_home_work_rounded)),
                  Tab(icon: Icon(Icons.supervised_user_circle)),
                  Tab(icon: Icon(Icons.design_services)),
                  Tab(icon: Icon(Icons.analytics_outlined)),
                ]),
            title: Text("Service Report"),
            elevation: 0,
            actions: [
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
          body: Container(
            child: Form(
              child: TabBarView(children: [
                ServiceFormTab1(context),
                ServiceFormTab2(context),
                ServiceFormTab3(context),
                ServiceFormTab4(context),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget ServiceFormTab1(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              onTap: () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return FutureBuilder<ListSpk>(
                        future: svc.getSpk(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Failed load API Data with error : ' +
                                        snapshot.error.toString()));
                          } else {
                            return Material(
                              child: Text('Hore Berhasil'),
                            );
                          }
                        },
                      );
                    }));
              },
              decoration: new InputDecoration(
                hintText: "Spk Number",
                labelText: "SPK",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                suffixIcon: GestureDetector(
                  child: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.search,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Service Category",
                labelText: "Category",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Working Start Date",
                labelText: "Start Date",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
              controller: dateInputController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050));
                if (pickedDate != null) {
                  dateInputController.text =
                      DateFormat('dd MMMM yyyy').format(pickedDate);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ServiceFormTab2(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Customer",
                labelText: "Customer",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Unit Site",
                labelText: "Site",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Province",
                labelText: "Province",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Unit SN",
                labelText: "SN",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Unit Brand",
                labelText: "Brand",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Unit Model",
                labelText: "Model",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Unit HM",
                labelText: "HM",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Unit KM",
                labelText: "KM",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Unit Status Before Service",
                labelText: "Status Before",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 15, top: 10, right: 15, left: 15),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: new InputDecoration(
                hintText: "Complaints",
                labelText: "Complaints",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ServiceFormTab3(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                //Add isDense true and zero Padding.
                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                //Add more decoration as you want here
                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
              ),
              isExpanded: false,
              hint: const Text(
                'Faulty Group',
                style: TextStyle(fontSize: 16),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 60,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              items: faulty
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Choose Faulty Group.';
                }
              },
              onChanged: (value) {
                //Do something when changing the item if you want.
              },
              onSaved: (value) {
                selectedValue1 = value.toString();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                //Add isDense true and zero Padding.
                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                //Add more decoration as you want here
                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
              ),
              isExpanded: false,
              hint: const Text(
                'Service Status',
                style: TextStyle(fontSize: 16),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 60,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              items: serviceStatus
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Choose Service Status';
                }
              },
              onChanged: (value) {
                //Do something when changing the item if you want.
              },
              onSaved: (value) {
                selectedValue1 = value.toString();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "End Date",
                labelText: "Working End Date",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
              controller: dateInputController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050));
                if (pickedDate != null) {
                  dateInputController.text =
                      DateFormat('dd MMMM yyyy').format(pickedDate);
                }
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: TextFormField(
              decoration: new InputDecoration(
                hintText: "Creator",
                labelText: "Report Creator",
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15),
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                //Add isDense true and zero Padding.
                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                //Add more decoration as you want here
                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
              ),
              isExpanded: false,
              hint: const Text(
                'Unit Status After Service',
                style: TextStyle(fontSize: 16),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 60,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              items: afterService
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Choose Status After Service';
                }
              },
              onChanged: (value) {
                //Do something when changing the item if you want.
              },
              onSaved: (value) {
                selectedValue1 = value.toString();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 10),
            child: SwitchListTile(
              title: Text('Need Spareparts Recommendation?'),
              value: light,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  light = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ServiceFormTab4(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5, top: 10, right: 15, left: 15),
              child: HtmlEditor(
                controller: analysis, //required
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Analysis",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(defaultToolbarButtons: [
                  FontButtons(),
                  ListButtons(),
                  FontSettingButtons(),
                  ParagraphButtons(),
                ]),
                otherOptions: OtherOptions(
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5, top: 10, right: 15, left: 15),
              child: HtmlEditor(
                controller: action, //required
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Action",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(defaultToolbarButtons: [
                  FontButtons(),
                  ListButtons(),
                  FontSettingButtons(),
                  ParagraphButtons(),
                ]),
                otherOptions: OtherOptions(
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 5, top: 10, right: 15, left: 15),
              child: HtmlEditor(
                controller: service_note, //required
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Service Note",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(defaultToolbarButtons: [
                  FontButtons(),
                  ListButtons(),
                  FontSettingButtons(),
                  ParagraphButtons(),
                ]),
                otherOptions: OtherOptions(
                  height: 200,
                ),
              ),
            )
          ]),
    );
  }
}
