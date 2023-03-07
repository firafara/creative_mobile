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
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:flutter_html/flutter_html.dart';

String? faultyValue;
String? serviceStatusValue;
String? statusAfterServiceValue;
bool isChecked = false;

class ServiceReportTab4 extends StatefulWidget {
  // const ServiceReportTab4({super.key});
  ServiceReportTab4(BuildContext context);

  @override
  State<ServiceReportTab4> createState() => _ServiceReportTab4State();
}

class _ServiceReportTab4State extends State<ServiceReportTab4> {
  SubmitServiceReport svc2 = SubmitServiceReport();

  SpkDBServices svc = SpkDBServices();
  SubmitServiceReport ssr = SubmitServiceReport();
  ConstantFunction cf = new ConstantFunction();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _startDateKey = GlobalKey();
  GlobalKey _endDateKey = GlobalKey();
  GlobalKey _actionKey = GlobalKey();
  GlobalKey _reportKey = GlobalKey();

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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

  bool validate() {
    return _formKey.currentState!.validate();
  }
}
