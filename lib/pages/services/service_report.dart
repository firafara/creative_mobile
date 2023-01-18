// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_import, implementation_imports, unnecessary_import, depend_on_referenced_packages, unnecessary_new, body_might_complete_normally_nullable, prefer_const_constructors

import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:creative_mobile/config.dart';
import 'package:creative_mobile/constants/input_decoration.dart';
import 'package:creative_mobile/constants/sr_const_list.dart';
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
import 'package:flutter_summernote/flutter_summernote.dart';

String? faultyValue;
String? serviceStatusValue;
String? statusAfterServiceValue;
bool isChecked = false;

final _formKey = GlobalKey<FormState>();

class ServiceReportPage extends StatefulWidget {
  const ServiceReportPage({super.key});
  @override
  State<ServiceReportPage> createState() => _ServiceReportPageState();
}

class _ServiceReportPageState extends State<ServiceReportPage> {
  final GlobalKey<FlutterSummernoteState> _keyEditorAnalysis = GlobalKey();
  final GlobalKey<FlutterSummernoteState> _keyEditorAction = GlobalKey();
  final GlobalKey<FlutterSummernoteState> _keyEditorServiceNote = GlobalKey();

  //harus ditambahkan disetiap inputan
  final TextEditingController spkID = TextEditingController();
  final TextEditingController spkNumberController = TextEditingController();
  final TextEditingController serviceCategoryController =
      TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController unitSiteController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController unitSnController = TextEditingController();
  final TextEditingController unitBrandController = TextEditingController();
  final TextEditingController unitModelController = TextEditingController();
  final TextEditingController unitHmController = TextEditingController();
  final TextEditingController unitKmController = TextEditingController();
  final TextEditingController complaintsController = TextEditingController();
  final TextEditingController faultyGroupController = TextEditingController();
  final TextEditingController reportCreatorController = TextEditingController();
  final TextEditingController unitStatusAfterController =
      TextEditingController();
  final TextEditingController unitStatusBeforeController =
      TextEditingController();
  final TextEditingController needSparepartsController =
      TextEditingController();
  final TextEditingController serviceStatusController = TextEditingController();

  // final HtmlEditorController analysisController = HtmlEditorController();
  // final HtmlEditorController serviceNoteController = HtmlEditorController();
  // final HtmlEditorController actionController = HtmlEditorController();

  SpkDBServices svc = SpkDBServices();

  String faultydropdownValue = faultyList.first;
  String serviceStatusdropdownValue = serviceStatusList.first;
  String statusAfterdropdownValue = afterServiceList.first;
  _RemovePF() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  _tes() async {
    final value = await _keyEditorAnalysis.currentState?.getText();
    final _value = _keyEditorAnalysis.currentState?.text = value!;
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<Widget> widgets = [
      ServiceFormTab1(context),
      ServiceFormTab2(context),
      ServiceFormTab3(context),
      ServiceFormTab4(context)
    ];
    return Builder(builder: (context) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Service Report"),
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
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                ),
              ),
              IconButton(
                onPressed: (() {
                  _RemovePF();
                  SharedService.logout(context);
                }),
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          bottomNavigationBar: ConvexAppBar(
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              const TabItem(icon: Icons.map_outlined, title: 'SPK'),
              TabItem(icon: Icons.people_alt, title: 'Customer'),
              TabItem(icon: Icons.message, title: 'Faulty'),
              TabItem(icon: Icons.analytics_outlined, title: 'Action'),
            ],
            onTap: (int i) {
              setState(() {
                currentIndex = i;
              });
              _tes();
            },
          ),
          body: Form(
            key: _formKey,
            child: widgets[currentIndex],
          ),
        ),
      );
    });
  }

  Widget ServiceFormTab1(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
                controller: spkNumberController,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return FutureBuilder<ListSpk>(
                          future: svc.getSpk(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Failed load API Data with error : ' +
                                          snapshot.error.toString()));
                            } else {
                              var listSPK = snapshot.data!.results;
                              return Material(
                                color: Colors.grey[200],
                                child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    itemCount: listSPK.length,
                                    itemBuilder: (context, index) {
                                      var spk = listSPK[index];
                                      int? id = spk.spk_id;
                                      return InkWell(
                                        onTap: () {
                                          spkID.text = id.toString();
                                          spkNumberController.text =
                                              spk.spk_number;
                                          serviceCategoryController.text =
                                              spk.service_category;
                                          customerNameController.text =
                                              spk.customer_name;
                                          unitSiteController.text =
                                              spk.unit_site;
                                          provinceController.text =
                                              spk.assignment_province;
                                          unitSnController.text = spk.unit_sn;
                                          unitBrandController.text =
                                              spk.unit_brand;
                                          unitModelController.text =
                                              spk.unit_model;
                                          unitStatusBeforeController.text =
                                              spk.unit_status_before_service;
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: ListView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.all(3),
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.lightBlue,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                                child: ListTile(
                                                  leading:
                                                      const Icon(Icons.circle),
                                                  title: Text(spk.spk_number),
                                                  subtitle: Text(
                                                      spk.customer_name +
                                                          '\t-\t' +
                                                          spk.unit_sn),
                                                  textColor: Colors.white,
                                                  tileColor: Colors.blue[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }
                          },
                        );
                      }));
                },
                decoration: inputDecoration("SPK Number", "SPK",
                    suffixIcon: GestureDetector(
                      child: const Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                    ))),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
              controller: serviceCategoryController,
              decoration: inputDecoration("Service Category", "Category"),
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
              decoration: inputDecoration("Working Start Date", "Start Date"),
              controller: startDateController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050));
                if (pickedDate != null) {
                  startDateController.text =
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
            padding: inputFieldPadding,
            child: TextFormField(
                controller: customerNameController,
                decoration: inputDecoration('Customer', 'Customer')),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
                controller: unitSiteController,
                decoration: inputDecoration('Unit Site', 'Site')),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
                controller: provinceController,
                decoration: inputDecoration('Province', 'Province')),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
              controller: unitSnController,
              decoration: inputDecoration('Unit SN', 'Serial Number'),
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
                controller: unitBrandController,
                decoration: inputDecoration('Unit Brand', 'Unit Brand')),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
                controller: unitModelController,
                decoration: inputDecoration('Unit Model', 'Unit Model')),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
              controller: unitHmController,
              decoration: inputDecoration('Unit HM', 'Unit HM'),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
              controller: unitKmController,
              decoration: inputDecoration('Unit KM', 'Unit KM'),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
                controller: unitStatusBeforeController,
                decoration: inputDecoration(
                    'Unit Status Before Service', 'Status Before')),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 30, top: 10, right: 15, left: 15),
            child: TextFormField(
                controller: complaintsController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: inputDecoration('Complaints', 'Complaints')),
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
            padding: inputFieldPadding,
            child: DropdownButtonFormField2(
              searchController: faultyGroupController,
              // value: faultydropdownValue,
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
              items: faultyList
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
              value: faultyValue,
              onChanged: (value) {
                setState(() {
                  faultyValue = value as String;
                });
              },
              onSaved: (value) {
                faultyValue = value.toString();
              },
              // value: dropdownValue,
              // icon: const Icon(Icons.arrow_downward),
              // style: const TextStyle(color: Colors.deepPurple),
              // onChanged: (String? value) {
              //   // This is called when the user selects an item.
              //   setState(() {
              //     dropdownValue = value!;
              //   });
              // },
              // items: faulty.map<DropdownMenuItem<String>>((String value) {
              //   return DropdownMenuItem<String>(
              //     value: value,
              //     child: Text(value),
              //   );
              // }).toList(),
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: DropdownButtonFormField2(
              searchController: serviceStatusController,
              // value: serviceStatusdropdownValue,
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
              items: serviceStatusList
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
              value: serviceStatusValue,
              onChanged: (value) {
                setState(() {
                  serviceStatusValue = value as String;
                });
              },
              onSaved: (value) {
                serviceStatusValue = value.toString();
              },
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
              decoration: inputDecoration('End Date', 'Working End Date'),
              controller: endDateController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050));
                if (pickedDate != null) {
                  endDateController.text =
                      DateFormat('dd MMMM yyyy').format(pickedDate);
                }
              },
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: TextFormField(
              controller: reportCreatorController,
              decoration: inputDecoration('Report Creator', 'Report Creator'),
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: DropdownButtonFormField2(
              searchController: unitStatusAfterController,
              // value: statusAfterdropdownValue,
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
              items: afterServiceList
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
              value: statusAfterServiceValue,
              onChanged: (value) {
                setState(() {
                  statusAfterServiceValue = value as String;
                });
              },
              onSaved: (value) {
                statusAfterServiceValue = value.toString();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 10),
            child: CheckboxListTile(
              title: const Text("Need Spareparts Recommendation?"),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
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
              padding: inputFieldPadding,
              child: FlutterSummernote(
                  showBottomToolbar: false,
                  hint: "Analysis...",
                  key: _keyEditorAnalysis,
                  height: 300,
                  customToolbar: """[
                    ['style', ['bold', 'italic', 'underline', 'clear']],
                    ['font', ['strikethrough', 'superscript', 'subscript']],
                    ['fontsize', ['fontsize']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['height', ['height']]
                  ]"""),
            ),
            Padding(
              padding: inputFieldPadding,
              child: FlutterSummernote(
                  showBottomToolbar: false,
                  hint: "Action...",
                  key: _keyEditorAction,
                  height: 300,
                  customToolbar: """[
                    ['style', ['bold', 'italic', 'underline', 'clear']],
                    ['font', ['strikethrough', 'superscript', 'subscript']],
                    ['fontsize', ['fontsize']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['height', ['height']]
                  ]"""),
            ),
            Padding(
              padding: inputFieldPadding,
              child: FlutterSummernote(
                  showBottomToolbar: false,
                  hint: "Service Note...",
                  key: _keyEditorServiceNote,
                  height: 300,
                  customToolbar: """[
                    ['style', ['bold', 'italic', 'underline', 'clear']],
                    ['font', ['strikethrough', 'superscript', 'subscript']],
                    ['fontsize', ['fontsize']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['height', ['height']]
                  ]"""),
            ),
            // Padding(
            //   padding: inputFieldPadding,
            //   child: HtmlEditor(
            //     controller: actionController, //required
            //     htmlEditorOptions: const HtmlEditorOptions(
            //       hint: "Action",
            //     ),
            //     htmlToolbarOptions:
            //         const HtmlToolbarOptions(defaultToolbarButtons: [
            //       FontButtons(),
            //       ListButtons(),
            //       FontSettingButtons(),
            //       ParagraphButtons(),
            //     ]),
            //     otherOptions: const OtherOptions(
            //       height: 200,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: inputFieldPadding,
            //   child: HtmlEditor(
            //     controller: serviceNoteController, //required
            //     htmlEditorOptions: const HtmlEditorOptions(
            //       hint: "Service Note",
            //     ),
            //     htmlToolbarOptions:
            //         const HtmlToolbarOptions(defaultToolbarButtons: [
            //       FontButtons(),
            //       ListButtons(),
            //       FontSettingButtons(),
            //       ParagraphButtons(),
            //     ]),
            //     otherOptions: const OtherOptions(
            //       height: 200,
            //     ),
            //   ),
            // ),
            Padding(
              padding: inputFieldPadding,
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5, bottom: 25, top: 10),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final _etEditor =
                          await _keyEditorAnalysis.currentState?.getText();
                    },
                    icon: const Icon(
                        Icons.save_as_outlined), //icon data for elevated button
                    label: const Text("SUBMIT"), //label text
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green, //elevated btton background color
                        minimumSize: const Size.fromHeight(50),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
