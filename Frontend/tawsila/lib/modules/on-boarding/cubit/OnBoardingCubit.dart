import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'OnBoardingStates.dart';

class OnBoardingCubit extends Cubit<OnBoardingStates> {
  OnBoardingCubit(): super(OnBoardingInitialState());
  static OnBoardingCubit get(context) => BlocProvider.of(context);



  var items = {};
  String language = "english";
  void setLanguage({
    required String l
  }) {
    language = l;
    emit(SetLanguageState());
  }

  void readJson() async{
    String fileName = language == "English"? "english": "arabic";
    items = {};
    final String response = await rootBundle.loadString('assets/languages/${fileName}.json');
    final data = await json.decode(response);
    items = data['OnBoarding'];
    emit(GetLanguageFromDatabaseState());
  }
}
