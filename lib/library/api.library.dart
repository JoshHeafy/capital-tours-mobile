import 'dart:convert' as convert;
import 'dart:convert';
import 'package:capital_tours_mobile/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localstore/localstore.dart';

class Apiv2 {
  Future<Map<String, dynamic>> exec(
    String url, {
    String api = "conductores",
    String method = "GET",
    bool file = false,
    bool auth = true,
    bool success = false,
    bool load = true,
    var data,
  }) async {
    String urlBase = "";
    switch (api) {
      case "other":
        urlBase = "";
        break;
      default:
        urlBase = "https://api-capital-tours.onrender.com/";
    }
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    final dynamic response;
    url = urlBase + url;
    if (auth) {
      final db = Localstore.instance;
      final dbStorage = await db.collection("session").doc("status").get();
      final token = dbStorage?["token"];
      if (token != null) {
        requestHeaders["Access-Token"] = token.toString();
      }
    }
    try {
      if (load) {
        Get.defaultDialog(
          title: 'Procesando...',
          onWillPop: () async {
            return false;
          },
          content: const CircularProgressIndicator(
            color: primaryColor,
          ),
          barrierDismissible: false,
        );
      }
      if (method == "GET") {
        response = await http.get(Uri.parse(url), headers: requestHeaders);
      } else if (method == "POST") {
        var temp = {};
        if (data != null) {
          temp = data;
        } else {
          temp = {};
        }
        var body = json.encode(temp);
        response = await http.post(Uri.parse(url),
            headers: requestHeaders, body: body);
      } else if (method == "PUT") {
        var temp = {};
        if (data != null) {
          temp = data;
        } else {
          temp = {};
        }
        var body = json.encode(temp);
        response =
            await http.put(Uri.parse(url), headers: requestHeaders, body: body);
      } else if (method == "DELETE") {
        response = await http.delete(Uri.parse(url), headers: requestHeaders);
      } else {
        if (load) {
          Get.back();
        }
        return {};
      }
      if (load) {
        Get.back();
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var body = convert.jsonDecode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
        if (body["statusCode"] == 200) {
          if (success) {
            launcherNotification(body, success: true);
          }
          Map<String, dynamic> data = body["data"] as Map<String, dynamic>;
          return data;
        } else {
          launcherNotification(body);
          return {};
        }
      } else {
        var body = convert.jsonDecode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
        if (body.isNotEmpty) {
          if (body["statusCode"] != null) {
            launcherNotification(body);
            return {};
          } else {
            launcherNotification({}, error: false);
            return {};
          }
        } else {
          launcherNotification({"msg": "Error desconocido"}, error: false);
          return {};
        }
      }
    } catch (e) {
      if (load) {
        Get.back();
      }
      launcherNotification({"msg": e}, error: false);
      throw Exception(e);
    }
  }

  void launcherNotification(Map<String, dynamic> response,
      {bool error = true, bool success = false}) {
    if (error = true) {
      if (response["statusCode"] == 100) {
        Fluttertoast.showToast(
            msg: response["msg"].toString(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.yellow,
            textColor: Colors.grey.shade700);
      } else if (response["statusCode"] == 200) {
        if (success == true) {
          Fluttertoast.showToast(
              msg: response["msg"].toString(),
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.green,
              textColor: Colors.grey.shade700);
        }
      } else if (response["statusCode"] == 201) {
        Fluttertoast.showToast(
            msg: response["msg"].toString(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.green,
            textColor: Colors.grey.shade700);
      } else if (response["statusCode"] == 300) {
        Fluttertoast.showToast(
            msg: response["msg"].toString(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.orange,
            textColor: Colors.grey.shade700);
      } else if (response["statusCode"] == 400) {
        Fluttertoast.showToast(
            msg: response["msg"].toString(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.grey.shade700);
      } else {
        Fluttertoast.showToast(
            msg: response["msg"].toString(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.grey.shade700);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Ha Ocurrido Un Error de Servidor!!',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black,
          textColor: Colors.grey.shade50);
    }
  }
}
