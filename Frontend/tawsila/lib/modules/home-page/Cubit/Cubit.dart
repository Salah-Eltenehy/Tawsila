import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';

import '../../../shared/components/Components.dart';
import '../../../shared/network/remote/DioHelper.dart';
import '../../../shared/end-points.dart';


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

import 'CubitStates.dart';

class HomePageCubit extends Cubit<HomePageStates> {

  HomePageCubit(): super(InitialHomePageStates());

  static HomePageCubit get(context) => BlocProvider.of(context);



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

  // late Position userCurrentPosition;
  // var geolocator = Geolocator();

  // void locatePosition() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high
  //   );
  // }

  Map<String, dynamic> usersInfo = {};
  Map<String, dynamic> tokenInfo={};

  void getUserInfo() async{
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

  Location location = new Location();
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData locationData;

  void getLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    locationData = await location.getLocation();
    CachHelper.saveData(key: 'latitude', value: locationData.latitude);
    CachHelper.saveData(key: 'longitude', value: locationData.longitude);
    print( locationData.latitude);
    userLocationLatidue =  locationData.latitude as double;
    userCurrentLongtidue = locationData.longitude as double;
    print("DONNNNNNNNNNNNNNNNNNNNNNNNNE");
    emit(GetLocationState());
  }
  var locationTTTT = "";
  void setLocation(value) {
    locationTTTT = value + "";
    emit(SetLocationState());
  }
  double userLocationLatidue = 0.0;
  double userLocationLongitude = 0.0;
  void setMapLocation(
      {
        required double latitude,
        required double longitude
      }
      ) {
    userLocationLatidue = latitude;
    userLocationLongitude = longitude;
    emit(SetLocationState());
  }
  double? userCurrentLatitude = 30.0444;
  double? userCurrentLongtidue = 31.2357;
  void getPrevLocation () async {
    userCurrentLatitude = await CachHelper.getData(key: "latitude") as double;
    userCurrentLongtidue = await CachHelper.getData(key: "longitude") as double;
    print("TEST                              sssssssssssss");
    print(userCurrentLongtidue);
    print(userCurrentLatitude);
    emit(GetLocationState());
  }
}