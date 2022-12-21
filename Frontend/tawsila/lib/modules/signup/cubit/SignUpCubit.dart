
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';

import '../../../shared/network/remote/DioHelper.dart';
import '../../../shared/end-points.dart';
import 'SignUpStates.dart';


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpCubit extends Cubit<SignUpStates> {
  
  SignUpCubit(): super(InitialSignUpState());

  static SignUpCubit get(context) => BlocProvider.of(context);



  var items = {};
  String language = "English";

  void setLanguage({
    required String l
  }) {
    language = l;
    emit(SetLanguageState());
  }
  void readJson(String get) async{
    items = {};
    String fileName = language == "English"? "english": "arabic";
    print(fileName);
    final String response = await rootBundle.loadString('assets/languages/${fileName}.json');
    final data = await json.decode(response);
    items = data[get];
    emit(GetLanguageFromDatabaseState());
  }

  bool passwordIsSecure = true;
  void changePasswordVisibility() {
    passwordIsSecure = !passwordIsSecure;
    emit(ChangePasswordVisibiltyState()); 
  }
  bool confirmPasswordIsSecure = true;
  void changeConfirmPasswordVisibility() {
    confirmPasswordIsSecure = !confirmPasswordIsSecure;
    emit(ChangeConfirmPasswordVisibiltyState()); 
  }

  bool hasWhatsApp = false;
  void hasWhatsAppFun() {
    hasWhatsApp = !hasWhatsApp;
    emit(HasWhatsAppChangeState()); 
  }

  bool termsAndConditions = false;
  void termsAndConditionsFun() {
    termsAndConditions = !termsAndConditions;
    emit(HasWhatsAppChangeState()); 
  }

  var hasWhatsAppColor = Color.fromARGB(255, 214, 214, 214);
  var agreeColor = Color.fromARGB(255, 214, 214, 214);
  void changeHasWhatsApp() {
      hasWhatsAppColor = Colors.red;
      agreeColor = termsAndConditions ?  Color.fromARGB(255, 214, 214, 214):  Colors.red;
      emit(HasNoWhatsAppState());
  }

  
  void agreeTermsAndConditionsColor() {
      hasWhatsAppColor = hasWhatsApp ?  Color.fromARGB(255, 214, 214, 214):  Colors.red;
      agreeColor = Colors.red;
      emit(AgreeTermsAndConditionsColorState());
  }

  late Map<String, dynamic> usersInfo;
  Map<String, dynamic> tokenInfo={};

  void getUserInfo() async{
    usersInfo = {};
    print("here###################################");
    String token = await CachHelper.getData(key: 'token') as String;
    tokenInfo = parseJwt(token);
    print(tokenInfo[USERID]);
    emit(TokenState());
    print(tokenInfo);
    print(GETUSER);
    DioHelper.getData(
        url: "users/${tokenInfo[USERID]}",
        query: {
          //'userId': "${tokenInfo[USERID]}"
        }, token: token,
    ).then((value) {
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
        print(value);
        print("value --------------------");
        usersInfo = value.data['users'][0];
        print(usersInfo);
        print("kkkkkkkkkkkkkkkkk");
        emit(GetUserInfoState());
    }).catchError((error) {
      print("************************************************************************");
      print(error.toString());
    });
  }

}

