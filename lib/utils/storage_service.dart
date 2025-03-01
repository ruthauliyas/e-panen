import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/pemanen.dart';

class StorageService {
  static Future<List<Pemanen>> loadPemanen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pemanenJson = prefs.getString('pemanen_list');
    if (pemanenJson != null) {
      List<dynamic> data = jsonDecode(pemanenJson);
      return data.map((e) => Pemanen.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> savePemanen(List<Pemanen> pemanenList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = jsonEncode(pemanenList.map((p) => p.toJson()).toList());
    await prefs.setString('pemanen_list', data);
  }
}
