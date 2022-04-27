import 'dart:developer';

import 'package:http/http.dart';
import 'package:token_app/utils/constants.dart';

class Network {
  static Future<String> post({payload, url}) async {
    try {
      var request = MultipartRequest(
        'POST',
        Uri.parse(Constants.baseUrl + url),
      );
      request.fields.addAll(payload);
      StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String res = await response.stream.bytesToString();
        return res;
      } else {
        return 'null';
      }
    } on Exception catch (e) {
      log('Error in post: $e');
      return 'null';
    }
  }

  static Future<String> postWithToken(
      {payload, required String token, url}) async {
    try {
      var headers = {
        'Authorization': 'Bearer $token',
      };
      var request = MultipartRequest(
        'POST',
        Uri.parse(Constants.baseUrl + url),
      );
      request.fields.addAll(payload);
      request.headers.addAll(headers);
      StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String res = await response.stream.bytesToString();
        return res;
      } else {
        return 'null';
      }
    } on Exception catch (e) {
      log('Error in post: $e');
      return 'null';
    }
  }

  static Future<String> get({required String token, required url}) async {
    try {
      var headers = {
        'Authorization': 'Bearer $token',
      };
      log('URL: ${Constants.baseUrl + url}');
      var request = Request('GET', Uri.parse(Constants.baseUrl + url));
      request.headers.addAll(headers);
      StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String res = await response.stream.bytesToString();
        return res;
      } else {
        log(response.reasonPhrase!);
        return 'null';
      }
    } on Exception catch (e) {
      log('Error in get: $e');
      return 'null';
    }
  }
}
