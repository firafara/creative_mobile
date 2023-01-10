import 'package:creative_mobile/models/spk.dart';

class ListSpk {
  late int page;
  late List<Spk> results = [];

  ListSpk.fromJson(Map<String, dynamic> json) {
    // json['data'] di dapat dari API
    json['data'].forEach((spk) {
      Spk mv = Spk.fromJson(spk);
      results.add(mv);
    });
  }
}
