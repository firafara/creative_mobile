import 'package:creative_mobile/models/spk.dart';

class ListSpk {
  late int page;
  late List<Spk> results = [];

  ListSpk.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    json['results'].forEach((spk) {
      Spk mv = Spk.fromJson(spk);
      results.add(mv);
    });
  }
}
