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

class ServiceReportTab2 extends StatefulWidget {
  // const ServiceReportTab2({super.key});
  ServiceReportTab2(BuildContext context);

  @override
  State<ServiceReportTab2> createState() => _ServiceReportTab2State();
}

class _ServiceReportTab2State extends State<ServiceReportTab2> {
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
    cf.getSPKCustomerName().then((cname) {
      setState(() {
        customerNameController.text = cname.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
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
              padding: const EdgeInsets.only(
                  bottom: 30, top: 10, right: 15, left: 15),
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
      ),
    );
  }

  bool validate() {
    return _formKey.currentState!.validate();
  }
}
