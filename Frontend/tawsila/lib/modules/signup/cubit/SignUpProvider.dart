import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'SignUpStates.dart';

class SignUpProvider extends Cubit<SignUpStates> {

  SignUpProvider(): super(InitialSignUpState());

  static SignUpProvider get(context) => BlocProvider.of(context);
  var items = {};
  String language = "English";

  void setLanguage({
    required String l
  }) {
    language = l;
    emit(SetLanguageState());
  }
  void readJson() async{
    items = {};
    String fileName = language == "English"? "english": "arabic";
    print(fileName);
    final String response = await rootBundle.loadString('assets/languages/${fileName}.json');
    final data = await json.decode(response);
    items = data['SignUp'];
    print(items);
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


}