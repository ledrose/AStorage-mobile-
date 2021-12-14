import 'package:flutter/material.dart';
import 'package:flutter_application_1/global_things/base.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey appKey = GlobalKey();
int batchSize = 5;
late ValueNotifier<int> currentTheme;
User curUser = User.empty();
SharedPreferences? prefs;
var themeList = {
  "Светлая тема": ThemeData.light(),
  "Темная тема": ThemeData.dark()
};

class DataSaver {
  static Future<void> initData() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void loadUser() {
    String token = prefs!.getString("token") ?? "";
    if (token == "") {
      curUser = User.empty();
    } else {
      List<String> permissions = prefs!.getStringList("permissions") ?? [];
      String name = prefs!.getString("name") ?? "";
      curUser = User.fromStorage(token, permissions, name);
    }
  }

  static void saveUser() {
    prefs!.setString("token", curUser.key);
    prefs!.setString("name", curUser.name ?? "");
    prefs!.setStringList("permissions", curUser.permissions);
  }

  static void removeUser() {
    prefs!.remove("token");
    prefs!.remove("permissions");
    prefs!.remove("name");
  }

  static void loadAppData() {
    currentTheme.value = prefs!.getInt("themeId") ?? 0;
    batchSize = prefs!.getInt("batchSize") ?? 5;
  }

  static void saveTheme() {
    prefs!.setInt("themeId", currentTheme.value);
  }

  static void saveBatchSize() {
    prefs!.setInt("batchSize", batchSize);
  }
}

class User {
  bool logged;
  String key;
  String? name;
  int? id;
  List<String> permissions;
  User._create({
    required this.key,
    required this.logged,
    this.permissions = const [],
    this.name,
  });

  factory User.fromToken(String token) {
    String tKey;
    if (token.contains("Bearer ")) {
      tKey = token;
    } else {
      tKey = "Bearer " + token;
    }
    return User._create(key: tKey, logged: true);
  }
  factory User.empty() {
    return User._create(key: "", logged: false);
  }
  factory User.fromStorage(
      String token, List<String> permissions, String name) {
    return User._create(
        key: token, logged: true, permissions: permissions, name: name);
  }

  Future recieveUserData() async {
    var response = await dioFetch(
      data: null,
      dirLink: "/Account",
      method: "GET",
      headers: {
        "Authorization": key,
      },
    );
    if (response.statusCode == 200) {
      id = response.data["id"];
      name = response.data["name"];
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future recievePermissions() async {
    var response = await dioFetch(
      data: null,
      dirLink: "/Account/Permissions",
      method: "GET",
      headers: {
        "Authorization": key,
      },
    );
    if (response.statusCode == 200) {
      permissions = [];
      List data = response.data as List;
      for (var e in data) {
        permissions.add(e["permission"]);
      }
    } else {}
  }
}
