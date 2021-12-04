import 'package:flutter/material.dart';
import 'package:flutter_application_1/global_things/base.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey appKey = GlobalKey();

late ValueNotifier<int> currentTheme;
User curUser = User.empty();
SharedPreferences? prefs;
var themeList = {
  "Светлая тема": ThemeData.light(),
  "Темная тема": ThemeData.dark()
};

String key =
    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3YjhiMDVhYy0yMDE5LTQ3MDQtYTA1My0wNDM0OTE4YWQzZDAiLCJpYXQiOjE2MzgyODgyNjcsIkNyZWF0aW9uRGF0ZXRpbWUiOiIxMS8zMC8yMDIxIDExOjA0OjI3IFBNIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6ImFkbWluQG1haWwucnUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhZG1pbkBtYWlsLnJ1Iiwic3ViIjoiMSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiMSIsInNlY3VyaXR5U3RhbXAiOiJFM0FDNzQ3R0xWNFlVVzJOUUNBTE0zMlFIWDREVVAzUSIsIkV4cGlyZXNJbiI6IjEwMDAwIiwiQ3JlYXRlUm9sZXMiOiIxIiwiRGVsZXRlRmlsZXMiOiIyIiwiR2V0TG9ncyI6IjIwMCIsIkRlbGV0ZVJvbGVzIjoiMyIsIlB1dEZpbGVzIjoiNCIsIkdldFJvbGVzIjoiNSIsIkVkaXRVc2VycyI6IjYiLCJHZXRVc2VycyI6IjciLCJBZGRVc2VycyI6IjgiLCJBZGRVc2VyVG9Sb2xlIjoiOSIsIlNlbmRFbWFpbCI6IjEwIiwibmJmIjoxNjM4Mjg4MjY3LCJleHAiOjE2NzQyODgyNjcsImlzcyI6Imh0dHBzOi8vYmZzLWFzdG9yYWdlLnNvbWVlLmNvbS8iLCJhdWQiOiJBU3RvcmFnZV9hcGkifQ.O96z5wyNiEFGHpA3SjTHa1MMNRazk8n9IpOHF5_iT_8";

class DataSaver {
  static Future<void> initData() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void loadUser() {
    String token = prefs!.getString("token") ?? "";
    List<String> permissions = prefs!.getStringList("permissions") ?? [];
    String name = prefs!.getString("name") ?? "";
    if (token == "") {
      curUser = User.empty();
    } else {
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

  static void loadTheme() {
    currentTheme.value=prefs!.getInt("themeId")??0;
  }
  
  static void saveTheme() {
    prefs!.setInt("themeId", currentTheme.value);
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
      print(response.statusMessage);
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
