
import 'dart:convert';
import 'dart:async';
import 'package:to_do/main.dart';

import '../Model/ResponseModel.dart';
import '../ViewModel/userViewModel.dart';
import 'package:http/http.dart' as http;

  class RequestHandler {
    String _accessToken = '';
  static const mainUrl =
  'https://phpstack-561490-3524079.cloudwaysapps.com/api-start-point/public/api';
  static const RefTokenUrl = 'https://phpstack-561490-3524079.cloudwaysapps.com/api-start-point/public/api/auth/refresh-token';

  Future<ResponseModel?> postData({
  required String endPoint,
  String param = '',
  bool auth = false,
  required Map<String, String> requestBody,
  }) async {
  var url = mainUrl + endPoint + param;
  var response = await http.post(
  Uri.parse(url),
  headers: auth
  ? {
  "Authorization": "Bearer ${UserViewModel.token}",
  "Content-Type": "application/json; charset=UTF-8"
  }
      : {"Content-Type": "application/json; charset=UTF-8"},
  body: json.encode(requestBody),
  );


  //redirectUrl
  if (response.statusCode == 302) {
  var redirectUrl = response.headers['location'];
  return await http.post(
  Uri.parse(redirectUrl!),
  headers: auth
  ? {
  "Authorization": "Bearer ${UserViewModel.token}",
  "Content-Type": "application/json; charset=UTF-8"
  }
      : {"Content-Type": "application/json; charset=UTF-8"},
  body: json.encode(requestBody),
  ).then((newResponse) {
  if (newResponse.statusCode >= 200 && newResponse.statusCode < 300) {
  return ResponseModel.Json(json.decode(newResponse.body));
  } else {
  return null;
  }
  }).catchError((error) {
  return null;
  });
  }

  //invalid token
  else if (response.statusCode == 401){
     refreshToken(UserViewModel.token!);
  }
  //normal
  if (response.statusCode >= 200 && response.statusCode < 300) {
  return ResponseModel.Json(json.decode(response.body));
  } else {
  return null;
  }
  }

  Future<String> refreshToken(String expiredToken) async {
    final headers = {'Authorization': 'Bearer $expiredToken'};

    final response = await http.post(Uri.parse(RefTokenUrl), headers: headers);

    if (response.statusCode == 200) {
      final newToken = response.body;
      return newToken;
    } else {
      throw Exception('Failed to refresh token');
    }
  }
  }
