class Spk {
  late String service_category;
  late String customer_name;
  late String unit_site;
  late String assignment_province;
  late String spk_number;
  late String unit_sn;
  late String unit_brand;
  late String unit_model;
  late String unit_status_before_service;
  late String service_complaints;
  late int? spk_id;

  Spk.fromJson(Map<String, dynamic> json) {
    service_category = json['service_category'] ?? "";
    customer_name = json['customer_name'] ?? "";
    unit_site = json['unit_site'] ?? "";
    assignment_province = json['assignment_province'] ?? "";
    spk_number = json['spk_number'] ?? "";
    unit_sn = json['unit_sn'] ?? "";
    unit_brand = json['unit_brand'] ?? "";
    unit_model = json['unit_model'] ?? "";
    unit_status_before_service = json['unit_status_before_service'] ?? "";
    service_complaints = json['service_complaints'] ?? "";
    spk_id = json['spk_id'] ?? 0;
  }
}
