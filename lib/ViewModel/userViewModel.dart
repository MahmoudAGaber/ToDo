
import 'dart:convert';
import 'package:flutter/material.dart';
import '../Data/RequestHandler.dart';
import '../Model/ResponseModel.dart';
import '../Model/UserModel.dart';
import '../main.dart';

class UserViewModel extends ChangeNotifier {
  RequestHandler requestHandler = RequestHandler();
  static UserModel? userModel;
  static String? token;
  bool _loginLoading = false;
  bool get getLoginLoading => _loginLoading;
  String? name;
  String? type;


  Future<UserModel?> login(String email,String password)async{
    Map<String,String> data = {
      "email": email,
      'password': password,
    };
    ResponseModel? responseModel = await requestHandler.postData(
        endPoint: '/auth/login',
        auth: false,
        requestBody: data,
    );

      if(responseModel?.message == "site.successfully_logged_in"){
        userModel =  UserModel.fromJson(responseModel!.data["user"]);
        token = responseModel.data["token"];
        await prefs!.setString('token', token!);
        return userModel;
      }else{
        return null;
      }

  }

  Future<bool?>userLogout()async{
    return await prefs!.clear();
  }

  void getSavedUser() async{
    userModel =  UserModel.fromJson(json.decode(prefs!.getString('user')!));
    notifyListeners();
  }


  void toggleLoading(bool loading){
    _loginLoading = loading;
    notifyListeners();
  }
}