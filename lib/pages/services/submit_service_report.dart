import 'dart:convert';

import 'package:http/http.dart' as http;

class SubmitServiceReport {
  submitServiceReport(data) async {
    var uri = Uri.http("192.168.10.132:8000", "/api/movie");

    var response = await http.post(uri, body: {
      "spk_id": data['spk_id'],
      "request_number": data['request_number'],
      "user_id": data['user_id'],
      "service_start_date": data['service_start_date'],
      "service_category": data['service_category'],
      "service_complaints": data['service_complaints'],
      "service_analysis": data['service_analysis'],
      "service_action": data['service_action'],
      "service_status": data['service_status'],
      "service_notes": data['service_notes'],
      "service_end_date": data['service_end_date'],
      "faulty_group": data['faulty_group'],
      "customer_id": data['customer_id'],
      "unit_sn": data['unit_sn'],
      "unit_status_before_service": data['unit_status_before_service'],
      "unit_hm": data['unit_hm'],
      "unit_km": data['unit_km'],
      "unit_status_after_service": data['unit_status_after_service'],
      "need_parts_recommendation": data['need_parts_recommendation'],
    });

    var hasil = json.decode(response.body);
  }
}
