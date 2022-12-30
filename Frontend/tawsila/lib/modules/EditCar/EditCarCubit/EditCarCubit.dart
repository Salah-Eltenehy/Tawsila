import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/network/local/Cachhelper.dart';
import '../../../../shared/network/remote/DioHelper.dart';
import 'EditCarStates.dart';

class EditCarCubit extends Cubit<EditCarStates>{

  EditCarCubit(): super(EditCarInitialState());

  static EditCarCubit get(context) => BlocProvider.of(context);

  String transmission = "automatic";

  String fuelType = "gasoline";

  List<bool> options = [true, false, false, false];
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
    "other": true
  };

  Map<String, bool> bodyTypes = {
    "Convertible": true,
    "Coupe": false,
    "Hatchback": false,
    "MPV": false,
    "SUV": false,
    "Sedan": false,
  };
  List<XFile>? images;

  final ImagePicker picker = ImagePicker();

  var img;
  List<dynamic> imgs = [];

  List<Uint8List> imgsFile = [];

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
    print("ssssssssssssssssssssssssssssssssssssssssss");
    print(data);
    items = data["editPage"];
    emit(GetLanguageFromDatabaseState());
  }

  void toggleTransmissionButton(value){
    transmission = value.toString();
    emit(ChangeTransmission());
  }
  void toggleGasButton(value){
    fuelType = value.toString();
    emit(ChangeGas());
  }

  void toggleOption(int i){
    options[i] = !options[i];
    emit(ChangeOption());
  }
  
  String finalBrand = "others";

  void changeBrand({required String brand}) {
    finalBrand = brand;
    for (var m in brands.entries) {
      if (m.key == brand) {
        brands[m.key] = true;
      }
      else {
        brands[m.key] = false;
      }
    }
    emit(ChangeCarBrand());
  }
  String bodyType = "Convertible";
  void changeBodyType({required String body_type}) {
    bodyType = body_type;
    for (var m in bodyTypes.entries) {
      if (m.key == body_type) {
        bodyTypes[m.key] = true;
      }
      else {
        bodyTypes[m.key] = false;
      }
    }
    emit(ChangeCarBody());
  }


  Map<String, dynamic> carResponse = {};
  Future<void> getCarById(id)  async {
    print("i am in the function");
    String token = await CachHelper.getData(key: 'token') as String;
    print("the toke is ${token}");
    DioHelper.getData(
        url: 'cars/${id}',
        token: token,
        query: {}
    ).then((value) async {
      print(value.data);
      carResponse = value.data;
      updateInfo(carResponse);
      emit(GetCarSuccessfully());
    });
  }


  void updateInfo(Map<String, dynamic> car){
      options[0] = car["hasAbs"];
      options[1] = car["hasAirConditioning"];
      options[2] = car["hasSunroof"];
      options[3] = car["hasRadio"];

      for (var m in bodyTypes.entries) {
        if (m.key == car["bodyType"]) {
          bodyTypes[m.key] = true;
        }
        else {
          bodyTypes[m.key] = false;
        }
      }

      for (var m in brands.entries) {
        if (m.key == car["brand"]) {
          brands[m.key] = true;
        }
        else {
          brands[m.key] = false;
        }
      }
        transmission = car["transmission"];
        fuelType = car["fuelType"];
        imgs = car["images"];

        // for(String i in imgs){
        //   imgsFile.add(Base64Decoder().convert(i));
        // }
  }


  Future<void> updateCar({required int id, required query}) async{
    String token = await CachHelper.getData(key:"token") as String;
    print("ddddddddddddddddddddddddddddddddd");
    print(query);
    DioHelper.putData(
        url: "cars/${id}",
        token: token,
        data: query
    ).then((value) async{
       print(value.data);
       emit(UpdateCarSuccessfully());
    }).catchError((error){
      print(error.toString());}
      );
  }

  Future<void> deleteCarById(id) async{
    String token = await CachHelper.getData(key:'token') as String;
    DioHelper.deleteData(
        url: "cars/${id}",
        token: token
    ).then((value) async{
      print(value.data);
      emit(DeleteCarSuccessfully());
    });
  }
}


