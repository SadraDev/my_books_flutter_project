import 'dart:convert';
import 'package:http/http.dart';

class Network {
  Network(this.url);

  final String url;

  Future<Map<String, dynamic>> getData() async {
    Uri _uri = Uri.parse(url);
    Response response = await get(_uri);

    if (response.statusCode == 200) {
      String data = response.body;

      return jsonDecode(data);
    } else {
      return {};
    }
  }
}
