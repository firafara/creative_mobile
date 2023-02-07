// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_import, implementation_imports, unnecessary_import, depend_on_referenced_packages, unnecessary_new, body_might_complete_normally_nullable, prefer_const_constructors

import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:creative_mobile/config.dart';
import 'package:creative_mobile/constants/constant_functions.dart';
import 'package:creative_mobile/constants/input_decoration.dart';
import 'package:creative_mobile/constants/sr_const_list.dart';
import 'package:creative_mobile/models/list_spk.dart';
import 'package:creative_mobile/pages/services/submit_service_report.dart';
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
import 'package:zefyrka/zefyrka.dart';

String? faultyValue;
String? serviceStatusValue;
String? statusAfterServiceValue;
bool isChecked = false;

class ServiceReportPage extends StatefulWidget {
  // const ServiceReportPage({Key? key, this.onSubmit}) : super(key: key);
  const ServiceReportPage({Key? key}) : super(key: key);

  // final ValueChanged<String>? onSubmit;
  @override
  State<ServiceReportPage> createState() => _ServiceReportPageState();
}

class _ServiceReportPageState extends State<ServiceReportPage> {
  SubmitServiceReport svc2 = SubmitServiceReport();

  SpkDBServices svc = SpkDBServices();
  SubmitServiceReport ssr = SubmitServiceReport();
  ConstantFunction cf = new ConstantFunction();

  // final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _startDateKey = GlobalKey();
  GlobalKey _endDateKey = GlobalKey();
  GlobalKey _actionKey = GlobalKey();
  GlobalKey _reportKey = GlobalKey();

  //harus ditambahkan disetiap inputan
  final analysisController = ZefyrController();
  final actionController = ZefyrController();
  final serviceNoteController = ZefyrController();
  final spkIdController = TextEditingController();
  final requestNumberController = TextEditingController();
  final userIDController = TextEditingController();
  final spkNumberController = TextEditingController();
  final serviceCategoryController = TextEditingController();
  final customerIDController = TextEditingController();
  final customerNameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final unitSiteController = TextEditingController();
  final provinceController = TextEditingController();
  final unitSnController = TextEditingController();
  final unitBrandController = TextEditingController();
  final unitModelController = TextEditingController();
  final unitHmController = TextEditingController();
  final unitKmController = TextEditingController();
  final complaintsController = TextEditingController();
  final faultyGroupController = TextEditingController();
  final reportCreatorController = TextEditingController();
  final unitStatusAfterController = TextEditingController();
  final unitStatusBeforeController = TextEditingController();
  final serviceStatusController = TextEditingController();
  String faultydropdownValue = faultyList.first;
  String serviceStatusdropdownValue = serviceStatusList.first;
  String statusAfterdropdownValue = afterServiceList.first;
  int currentIndex = 0;
  late String _username;
  late int? _uid;

  @override
  void initState() {
    super.initState();
    cf.getUserName().then((username) {
      setState(() {
        _username = username;
        reportCreatorController.text = _username;
      });
    });
    cf.getUserID().then((uid) {
      setState(() {
        _uid = uid;
        userIDController.text = _uid.toString();
      });
    });
  }

  void _submit() {
    Map<String, dynamic> inputValue = {
      "spk_id": spkIdController.text,
      "request_number": requestNumberController.text,
      "user_id": userIDController.text,
      "service_start_date": startDateController.text,
      "service_category": serviceCategoryController.text,
      "service_complaints": complaintsController.text,
      "service_analysis": analysisController.document.toPlainText(),
      "service_action": actionController.document.toPlainText(),
      "service_status": serviceStatusdropdownValue,
      "service_notes": serviceNoteController.document.toPlainText(),
      "service_end_date": endDateController.text,
      "faulty_group": faultydropdownValue,
      "customer_id": customerIDController.text,
      "unit_sn": unitSnController.text,
      "report_creator": reportCreatorController.text,
      "unit_status_before_service": unitStatusBeforeController.text,
      "unit_hm": unitHmController.text,
      "unit_km": unitKmController.text,
      "unit_status_after_service": statusAfterdropdownValue,
      "need_parts_recommendation": (isChecked == true) ? 1 : 0,
    };
    // if (_errorText == null) {
    print('input value : ' + reportCreatorController.value.text);
    // widget.onSubmit!(reportCreatorController.value.text);
    ssr.submitServiceReport(inputValue);
    // }
    // print(actionController.document.toPlainText());
  }

  @override
  Widget build(BuildContext context) {
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
            centerTitle: true,
            automaticallyImplyLeading: true,
            title: Text("Service Report"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  //  if (formKey1.currentState.validate() && formKey2.currentState.validate()) {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    _submit();
                    setState(() {});
                  } else {}
                },
                icon: const Icon(
                  Icons.save_alt,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          bottomNavigationBar: ConvexAppBar(
              items: [
                TabItem(icon: Icons.map_outlined, title: 'SPK'),
                TabItem(icon: Icons.people_alt, title: 'Customer'),
                TabItem(icon: Icons.message, title: 'Faulty'),
                TabItem(icon: Icons.analytics_outlined, title: 'Action'),
              ],
              onTap: (int i) {
                setState(() {
                  currentIndex = i;
                  // _formKey.currentState?.reset();
                });
              }),
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
        children: <Widget>[
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
                                      var id = spk.spk_id;
                                      return InkWell(
                                        onTap: () {
                                          spkIdController.text = id.toString();
                                          spkNumberController.text =
                                              spk.spk_number;
                                          requestNumberController.text =
                                              spk.spk_number;
                                          serviceCategoryController.text =
                                              spk.service_category;
                                          customerNameController.text =
                                              spk.customer_name;
                                          customerIDController.text =
                                              spk.customer_id.toString();
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
                                              const EdgeInsets.only(top: 15),
                                          child: ListView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.all(2),
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                                child: ListTile(
                                                  leading: SizedBox(
                                                    // color: backColor,
                                                    width: 60,
                                                    height: 60,
                                                    child: Image.asset(
                                                        'assets/icons/spk1.PNG',
                                                        fit: BoxFit.fill),
                                                  ),
                                                  title: Text(spk.spk_number),
                                                  subtitle: Text(
                                                      spk.customer_name +
                                                          '\t-\t' +
                                                          spk.unit_sn),
                                                  trailing:
                                                      Icon(Icons.chevron_right),
                                                  textColor: Colors.white,
                                                  tileColor: Color(0xff5271ff),
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
            key: _startDateKey,
            padding: inputFieldPadding,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Working Start Date is not choosen!';
                }
                return null;
              },
              decoration: inputDecoration(
                'Start Date',
                'Working Start Date',
              ),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Unit HM cannot be empty!';
                }
                return null;
              },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Status Before Service cannot be empty!';
                  }
                  return null;
                },
                controller: unitStatusBeforeController,
                decoration: inputDecoration(
                    'Unit Status Before Service', 'Status Before')),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 30, top: 10, right: 15, left: 15),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Complaints cannot be empty!';
                }
                return null;
              },
              controller: complaintsController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: inputDecoration('Complaints', 'Complaints'),
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
            padding: inputFieldPadding,
            child: DropdownButtonFormField2(
              searchController: faultyGroupController,
              // value: faultydropdownValue,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: inputBorder,
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
              dropdownDecoration: dropDownDecoration,
              items: faultyList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: inputHintText(item),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Faulty Group is not choosen!';
                }
                return null;
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
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: DropdownButtonFormField2(
              searchController: serviceStatusController,
              // value: serviceStatusdropdownValue,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: inputBorder,
              ),
              isExpanded: false,
              hint: inputHintText("Service Status"),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 60,
              dropdownDecoration: dropDownDecoration,
              items: serviceStatusList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: inputHintText(item),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Service Status is not choosen!';
                }
                return null;
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
            key: _endDateKey,
            padding: inputFieldPadding,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Working End Date is not choosen!';
                }
                return null;
              },
              decoration: inputDecoration(
                'End Date',
                'Working End Date',
              ),
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
              key: _reportKey,
              controller: reportCreatorController,
              decoration: inputDecoration('Report Creator', 'Report Creator'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Report Creator cannot be empty !';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: inputFieldPadding,
            child: DropdownButtonFormField2(
              searchController: unitStatusAfterController,
              // value: statusAfterdropdownValue,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: inputBorder,
              ),
              isExpanded: false,
              hint: inputHintText('Unit Status After Service'),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 60,
              dropdownDecoration: dropDownDecoration,
              items: afterServiceList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: inputHintText(item),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Status After Service is not choosen!';
                }
                return null;
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
          const SizedBox(
            height: 20,
          ),
          FormField<NotusDocument>(
            initialValue: analysisController.document,
            validator: (NotusDocument? value) {
              // print(analysisController.document.toPlainText());
              if (value!.toPlainText().trim().isEmpty) {
                return 'Analysis cannot be empty!';
              }
              return null;
            },
            onSaved: (NotusDocument? value) {
              // save the value
            },
            builder: (state) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text('Analysis',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                    ZefyrToolbar.basic(
                      controller: analysisController,
                      hideLink: true,
                      hideQuote: true,
                      hideCodeBlock: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: ZefyrEditor(
                          controller: analysisController,
                          minHeight: 100,
                        ),
                      ),
                    ),
                    if (state.hasError)
                      Text(
                        state.errorText!,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          FormField<NotusDocument>(
            initialValue: actionController.document,
            validator: (NotusDocument? value) {
              // print(actionController.document.toPlainText());
              if (value!.toPlainText().trim().isEmpty) {
                return 'Action cannot be empty!';
              }
              return null;
            },
            onSaved: (NotusDocument? value) {
              // save the value
            },
            builder: (state) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text('Action',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                    ZefyrToolbar.basic(
                      controller: actionController,
                      hideLink: true,
                      hideQuote: true,
                      hideCodeBlock: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: ZefyrEditor(
                          controller: actionController,
                          minHeight: 100,
                        ),
                      ),
                    ),
                    if (state.hasError)
                      Text(
                        state.errorText!,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Service Note',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left),
                ZefyrToolbar.basic(
                  controller: serviceNoteController,
                  hideLink: true,
                  hideQuote: true,
                  hideCodeBlock: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: ZefyrEditor(
                      controller: serviceNoteController,
                      minHeight: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
