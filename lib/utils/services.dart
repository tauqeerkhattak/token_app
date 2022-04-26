import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:token_app/models/category_data.dart';
import 'package:token_app/models/user_data.dart';

import 'network.dart';

class Services {
  static final GetStorage _box = GetStorage();

  static Future<UserData?> login ({required String email,required String password}) async {
    String response = await Network.post(
      payload: {
        'email': email,
        'password': password,
      },
      url: 'login',
    );
    if (response != 'null') {
      _box.write('user', response);
      UserData user = UserData.fromMap(jsonDecode(response));
      return user;
    }
    else {
      return null;
    }
  }

  static Future<CategoryData?> getCategories () async {
    String user = _box.read('user');
    UserData userData = UserData.fromMap(jsonDecode(user));
    log(userData.token!);
    String response = await Network.get(token: userData.token!, url: 'categories');
    if (response != 'null') {
      CategoryData data = CategoryData.fromMap(jsonDecode(response));
      return data;
    }
    else {
      return null;
    }
  }
}