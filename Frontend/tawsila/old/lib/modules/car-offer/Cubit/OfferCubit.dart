import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'OfferStates.dart';

class OfferCubit extends Cubit<OfferStates>{

  OfferCubit(): super(OfferInitialState());

  static OfferCubit get(context) => BlocProvider.of(context);
  String transmission = "A";
  String fuelType = "g";
  List<bool> options = [false, false, false, false];
  List<String> title = ["Aps", "Air Condition", "Sunroof", "Radio"];
  Map<String, bool> brands = {
    "lada": false,
    "verna": false,
    "daewoo": false,
    "nissan": false,
    "elantra": false,
    "kia": false,
    "bmw": false,
    "mercedes": false,
    "fiat": false,
    "other": false
  };
  Map<String, bool> moreBrands = {
    "Convertible": false,
    "Coupe": false,
    "Hatchback": false,
    "MPV": false,
    "SUV": false,
    "Sedan": false,
  };
  List<XFile>? images;
  final ImagePicker picker = ImagePicker();


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

  void toggleTransmissionButton(value){
    transmission = value.toString();
    emit(TransmissionSelection());
  }
  void toggleGasButton(value){
    fuelType = value.toString();
    emit(GasSelection());
  }

  void toggleOption(int i){
    options[i] = !options[i];
    emit(ChooseOption());
  }

  void pickImage() async{
    var pickedFiles = await picker.pickMultiImage();
    if(pickedFiles != null){
      print("images is selected: ${pickedFiles.length}");
      images = pickedFiles;
      emit(SelectImage());
    }
    else{
      print("No image is selected");
    }
  }


  void changeBrand({required String brand}) {
    for (var m in brands.entries) {
      if (m.key == brand) {
        brands[m.key] = true;
      }
      else {
        brands[m.key] = false;
      }
    }
    emit(SelectCarBrand());
  }
  void changeMoreBrand({required String brand}) {
    for (var m in moreBrands.entries) {
      if (m.key == brand) {
        moreBrands[m.key] = true;
      }
      else {
        moreBrands[m.key] = false;
      }
    }
    emit(SelectMoreCarBrand());
  }
}
