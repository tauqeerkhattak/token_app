import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:token_app/models/category_data.dart';
import 'package:token_app/models/user_data.dart';

import 'network.dart';

class Services {
  static final GetStorage _box = GetStorage();

  static Future<UserData?> login(
      {required String email, required String password}) async {
    String response = await Network.post(
      payload: {
        'email': email,
        'password': password,
      },
      url: 'login',
    );
    print(response);
    if (response != 'null') {
      _box.write('user', response);
      final data = jsonDecode(response);
      data.keys;
      UserData user = UserData.fromMap(jsonDecode(response));
      return user;
    } else {
      return null;
    }
  }

  static Future<CategoryData?> getCategories() async {
    String user = _box.read('user');
    UserData userData = UserData.fromMap(jsonDecode(user));
    log(userData.token!);
    String response =
        await Network.get(token: userData.token!, url: 'categories');
    if (response != 'null') {
      CategoryData data = CategoryData.fromMap(jsonDecode(response));
      return data;
    } else {
      return null;
    }
  }

  static Future<String> getTokenNumber(String categoryId) async {
    String user = _box.read('user');
    UserData userData = UserData.fromMap(jsonDecode(user));
    String response = await Network.get(
        token: userData.token!,
        url: 'get_token_number/$categoryId/${userData.data!.cityId}');
    var data = jsonDecode(response);
    if (data['status'] == 'Error' || data['status'] == 'error') {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(data['message']),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return 'null';
    } else {
      return data['token_number'].toString();
    }
  }

  static Future<void> logout() async {
    await _box.erase();
  }

  static Future<dynamic> generateToken(
      {required String categoryId, required String tokenNumber}) async {
    String user = _box.read('user');
    UserData userData = UserData.fromMap(jsonDecode(user));
    String response = await Network.postWithToken(
      payload: {
        'category_id': categoryId,
        'token_number': tokenNumber,
        'city_id': userData.data!.cityId.toString(),
      },
      token: userData.token!,
      url: 'generate/token',
    );
    print(response);
    var data = jsonDecode(response);
    if (data['status'] == 'success') {
      return data;
    } else if (data['status'] == 'error') {
      return data;
    }
    return 'null';
  }
}
