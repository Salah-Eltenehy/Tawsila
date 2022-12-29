import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tawsila/modules/search-result/cubit/SearchStates.dart';
import 'package:tawsila/shared/end-points.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';

import '../../../shared/network/local/Cachhelper.dart';

class SearchCubit extends Cubit<SearchStates> {

  SearchCubit(): super(InitialSearchStates());

  static SearchCubit get(context) => BlocProvider.of(context);

  late List cars;
  int totalCount = -1;
  double latitude = 0.0;
  double longitude = 0.0;


  void getLocation() async {
    latitude = await CachHelper.getData(key: "latitude") as double;
    longitude = await CachHelper.getData(key: "longitude") as double;
  }
  void getData({
  required Map<String, dynamic> query
  }) async {
    print("i am heeeeerrrrrreeeee");
    String token = await CachHelper.getData(key: 'token');
    print("out of herrrrrrrrrrrrre");
    await DioHelper.getData(url: SEARCHRESULTS,token:  token,query: query)
        .then((value) {
          //print("lalalalaalallalallaalaalla");
          cars = value.data['cars'];
          print("data: ${cars}");
          totalCount = value.data['totalCount'] as int;
          print(totalCount);
          emit(state);
         });
  }

  Map<String, dynamic> car = {
    "images": [
      "assets/images/2.png",
      "assets/images/2.png",
      "assets/images/2.png",
      "assets/images/2.png",
    ],// avatar
    "ownerImage": "assets/images/owner.png",
    "ownerName": "Salah Ahmed",
    "price": "500",
    "location": "Alexandria",
    "maxDays": 3,
    "fuelType": "Natural Gas",
    "seatsCount": 4,
    "year": 2022,
    "air": true,
    "radio": true,
    "gear": "Manual",
    "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    "reviews": [
      {
        "content": "Very good car",
        "image": "assets/images/1.png",
        "reviewerFirstName": "Salah",
        "reviewerLastName": "Ahmed",
        "rating": 3
      },
      {
        "content": "bla bla bla",
        "image": "assets/images/2.png",
        "reviewerFirstName": "Salah",
        "reviewerLastName": "Ahmed",
        "rating": 4.5
      },
      {
        "content": "Nice car",
        "image": "assets/images/owner.png",
        "reviewerFirstName": "Salah",
        "reviewerLastName": "Ahmed",
        "rating": 2.5
      },
    ]
  };
  Map<String, dynamic> userInfo = {};
  Future<void> getUserById(id) async {
    emit(GetUserByIDState());
    String token = await CachHelper.getData(key: 'token') as String;
    DioHelper.getData(
      url: "users/${id}",
      query: {
      }, token: token,
    ).then((value) {
      print("useeeeeeeeeeeeeeeeeeeeeeeeeeer");
      print(value.data);
      userInfo = value.data['users'][0];
      emit(GetUserByIdSuccessState());
    }).catchError((error) {
    });
  }
  List<Map<String, dynamic>> reviews = [];
  double averageRating = 0;
  double offset = 0;
  Future<void> getUserReviewsById(id) async {
    emit(GetUserReviewsByIDState());
    String token = await CachHelper.getData(key: 'token') as String;
    DioHelper.getData(
      url: "users/${id}/reviews",
      query: {
      }, token: token,
    ).then((value) {
      print("reeeeeviewwwwwwwwwwwwwwwwwwwwww");
      print(value.data);
      reviews = value.data['reviews'];
      averageRating = value.data['averageRating'];
      offset = value.data['offset'];
      emit(GetUserReviewsByIdSuccessState());
    }).catchError((error) {
    });
  }
  Map<String, dynamic> carResponse = {};
  String carCity = "";
  Future<void> getCarById(id)  async {
    print(id);
    String token = await CachHelper.getData(key: 'token') as String;
    DioHelper.getData(
        url: 'car/${id}',
        token: token,
        query: {}
    ).then((value) async {
      print("ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
      print(value.data);
      carResponse = value.data['car'];
      double carLatitude = value.data['latitude'];
      double carLongitude = value.data['longitude'];
      List<Placemark> placemarks = await placemarkFromCoordinates(carLatitude, carLongitude);
      carCity = placemarks[0].administrativeArea as String;
      emit(GetCarSuccessState());
    });
  }
}