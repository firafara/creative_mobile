// ignore_for_file: depend_on_referenced_packages, implementation_imports, unnecessary_import

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class SubmitServiceReportWidget extends StatefulWidget {
  const SubmitServiceReportWidget({super.key});

  @override
  State<SubmitServiceReportWidget> createState() =>
      _SubmitServiceReportWidgetState();
}

class _SubmitServiceReportWidgetState extends State<SubmitServiceReportWidget> {
  var f = GlobalKey<FormState>();
  var spkNumber = TextEditingController();
  var spkId = TextEditingController();
  var category = TextEditingController();
  var servicestartDate = TextEditingController();
  var customerId = TextEditingController();
  var complaints = TextEditingController();
  var analysis = TextEditingController();
  var action = TextEditingController();
  var serviceStatus = TextEditingController();
  var notes = TextEditingController();
  var serviceEndDate = TextEditingController();
  var faultyGroup = TextEditingController();
  var unitSN = TextEditingController();
  var unitStatusBefore = TextEditingController();
  var unitHM = TextEditingController();
  var unitKM = TextEditingController();
  var unitStatusAfter = TextEditingController();
  var partsRecommendation = TextEditingController();
  var isSubmit = false;

  submitServiceReport(data) async {
    var uri = Uri.http("192.168.10.132:8000", "/api/movie");
    var isiSpkId = spkId.text;
    var isiSpkNumber = spkNumber.text;
    var isiCategory = category.text;
    var isiStartDate = servicestartDate.text;
    var isiCustomerId = customerId.text;
    var isiComplaints = complaints.text;
    var isiAnalysis = analysis.text;
    var isiAction = action.text;
    var isiServiceStatus = serviceStatus.text;
    var isiNotes = notes.text;
    var isiEndDate = serviceEndDate.text;
    var isiFaultyGroup = faultyGroup.text;
    var isiUnitSN = unitSN.text;
    var isiStatusBefore = unitStatusBefore.text;
    var isiHM = unitHM.text;
    var isiKM = unitKM.text;
    var isiStatusAfter = unitStatusAfter.text;
    var isiPartsRecommendation = partsRecommendation.text;

    var response = await http.post(uri, body: {
      "spk_id": isiSpkId,
      "request_number": isiSpkNumber,
      "service_category": isiCategory,
      "service_start_date": isiStartDate,
      "customer_id": isiCustomerId,
      "service_complaints": isiComplaints,
      "service_analysis": isiAnalysis,
      "service_action": isiAction,
      "service_status": isiServiceStatus,
      "service_notes": isiNotes,
      "service_end_date": isiEndDate,
      "faulty_group": isiFaultyGroup,
      "unit_sn": isiUnitSN,
      "unit_status_before_service": isiStatusBefore,
      "unit_hm": isiHM,
      "unit_km": isiKM,
      "unit_status_after_service": isiStatusAfter,
      "need_parts_recommendation": isiPartsRecommendation,
    });

    var hasil = json.decode(response.body);
    isSubmit = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
