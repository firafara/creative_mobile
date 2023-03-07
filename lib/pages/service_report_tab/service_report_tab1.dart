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
// import 'package:quill_delta/quill_delta.dart';
import 'package:flutter_html/flutter_html.dart';

class ServiceReportTab1 extends StatefulWidget {
  // const ServiceReportTab1({super.key});
  ServiceReportTab1(BuildContext context);

  @override
  State<ServiceReportTab1> createState() => _ServiceReportTab1State();
}

class _ServiceReportTab1State extends State<ServiceReportTab1> {
  SubmitServiceReport svc2 = SubmitServiceReport();

  SpkDBServices svc = SpkDBServices();
  SubmitServiceReport ssr = SubmitServiceReport();
  ConstantFunction cf = new ConstantFunction();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _startDateKey = GlobalKey();
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
                                          cf.setSPKValue(
                                              spk.customer_id,
                                              spk.customer_name,
                                              spk.unit_site,
                                              spk.assignment_province,
                                              spk.unit_sn,
                                              spk.unit_brand,
                                              spk.unit_model,
                                              spk.unit_status_before_service);

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

  bool validate() {
    return _formKey.currentState!.validate();
  }
}
