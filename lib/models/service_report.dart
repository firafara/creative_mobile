class ServiceReport {
  late int spk_id;
  late int request_number;
  late int user_id;
  late String service_start_date;
  late String service_category;
  late String service_complaints;
  late String service_analysis;
  late String service_action;
  late String service_status;
  late String service_notes;
  late String service_end_date;
  late String faulty_group;
  late String customer_id;
  late String unit_sn;
  late int report_creator;
  late String unit_status_before_service;
  late String unit_hm;
  late String unit_km;
  late String unit_status_after_service;
  late String need_parts_recommendation;

  ServiceReport.fromJson(Map<String, dynamic> json) {
    spk_id = json['spk_id'] ?? 0;
    request_number = json['request_number'] ?? 0;
    user_id = json['user_id'] ?? 0;
    service_start_date = json['service_start_date'] ?? "";
    service_category = json['service_category'] ?? "";
    service_complaints = json['service_complaints'] ?? "";
    service_analysis = json['service_analysis'] ?? "";
    service_action = json['service_action'] ?? "";
    service_status = json['service_status'] ?? "";
    service_notes = json['service_notes'] ?? "";
    service_end_date = json['service_end_date'] ?? "";
    faulty_group = json['faulty_group'] ?? "";
    report_creator = json['report_creator'] ?? 0;
    unit_sn = json['unit_sn'] ?? "";
    customer_id = json['customer_id'] ?? "";
    unit_status_before_service = json['unit_status_before_service'] ?? "";
    unit_hm = json['unit_hm'] ?? "";
    unit_km = json['unit_km'] ?? "";
    unit_status_after_service = json['unit_status_after_service'] ?? "";
    need_parts_recommendation = json['need_parts_recommendation'] ?? "";
  }
}
