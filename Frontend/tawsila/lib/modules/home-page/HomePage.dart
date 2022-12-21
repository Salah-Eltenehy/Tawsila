import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/home-page/Cubit/Cubit.dart';
import 'package:tawsila/modules/home-page/Cubit/CubitStates.dart';
import 'package:tawsila/modules/home-page/Map.dart';
import 'package:tawsila/modules/search-result/SearchResultScreen.dart';
import 'package:tawsila/shared/components/Components.dart';

import '../../shared/network/local/Cachhelper.dart';
import '../Setting/SettingsScreen.dart';
import '../car-offer/CarOfferScreen.dart';

class HomePageScreen extends StatelessWidget {
  final language;

  HomePageScreen({super.key, required this.language});

  var items = {};

  var rentCarPeriodController = TextEditingController();

  var addressOfPicupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double imageSize = (MediaQuery.of(context).size.width * 120.0) / 500.0;
    double fontSize = (MediaQuery.of(context).size.width * 20.0) / 500.0;

    // TODO: implement build
    return BlocProvider(
      create: (BuildContext context) => HomePageCubit()..setLanguage(l: language)..readJson('HomePage'),
      child: BlocConsumer<HomePageCubit , HomePageStates>(
          listener: (BuildContext context, state) {},
          builder: (BuildContext context, state)
          {
            var homePageCubit = HomePageCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                  title: Text(
                    "${homePageCubit.items['title'] ?? ''}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        print("User page");
                        navigateTo(context: context, screen: EditProfilePageState(language: language, edit: false,));
                      },
                      child: const CircleAvatar(
                        child: Image(
                          image: AssetImage('assets/images/owner.png')
                        ),
                      ),
                    ),
                  ]
              ),
              body: Directionality(
                textDirection: homePageCubit.language == "English"? TextDirection.ltr: TextDirection.rtl,
                child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              buildPageItem(
                                title1: homePageCubit.items['offerCar1']??'',
                                title2: homePageCubit.items['offerCar2']??'',
                                image: AssetImage('assets/images/car.png'),
                                onTapFunc: () {
                                  navigateTo(context: context, screen: CarOfferScreen(language: language));
                                  print("Offer Car page");
                                  print("Width = ${imageSize}");
                                },
                                imageSize: imageSize,
                                fontSize: fontSize,
                              ),

                              SizedBox(
                                width: 10,
                              ),//NetworkImage('https://th.bing.com/th/id/R.280fb39f068a60a24a394031803a8e57?rik=dN2s3DxSChBFvw&pid=ImgRaw&r=0')
                              buildPageItem(
                                title1: homePageCubit.items['offers1']??'',
                                title2: homePageCubit.items['offers2']??'',
                                image: AssetImage('assets/images/label.png'),
                                onTapFunc: () {
                                  print("Manage Your offer page");
                                  print("Width = ${imageSize}");
                                },
                                imageSize: imageSize,
                                fontSize: fontSize,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${homePageCubit.items['RentCar']??''}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                              '${homePageCubit.items['RentalPeriod']??''}'
                          ),
                          buildTextField(controller: rentCarPeriodController, placeHolder: homePageCubit.items['RentalPeriodHint']?? ''),
                          SizedBox(
                            height: 8,
                          ),
                          Text('${homePageCubit.items['AddressOfPickup'] ?? ''}'),
                          buildTextField(controller: addressOfPicupController, placeHolder: homePageCubit.items['AddressOfPickupHint']?? ''),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                              // width: double.infinity,
                              child: InkWell(
                                onTap: () {
                                  navigateTo(context: context, screen: MapScreen());
                                },
                                child: Image(
                                  // image: NetworkImage('https://th.bing.com/th/id/OIP.3g6HqqAnz-PK2SmNWsUfbwHaHa?w=178&h=180&c=7&r=0&o=5&pid=1.7')
                                  image: AssetImage('assets/images/map.png'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async{
                              double latitude = await CachHelper.getData(key: "latitude") as double;
                              double longitude = await CachHelper.getData(key: "longitude") as double;
                              Map<String, dynamic> query = {
                                "brands": "",
                                "fuelTypes": "",
                                "hasAbs": "",
                                "hasAirConditioning": "",
                                "hasRadio": "",
                                "hasSunroof": "",
                                "latitude": 27.5667,
                                "longitude": 53.9,
                                "maxPrice":"",
                                "maxYear":"",
                                "minPrice":"",
                                "minYear":"",
                                "models":"",
                                "offset": "",
                                "seatsCount": "",
                                "sortBy":"",
                                "transmission":"",
                              };
                              navigateTo(context: context, screen: SearchResultScreen(query: query,));
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${homePageCubit.items['searchResults'??'']}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            );}
      ),
    );
  }


//${homePageCubit.items['offerCar1']??''}
//${homePageCubit.items['offerCar2']??''}
  Widget buildPageItem({
    required String title1,
    required String title2,
    required  image,
    required Function onTapFunc,
    required double imageSize,
    required double fontSize,
  }) => Expanded(
    child: InkWell(
      onTap: () {
        onTapFunc();
      },
      child: Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${title1}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${title2}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Text(''),
                Spacer(),
                Image(
                    width: imageSize,
                    height: imageSize,
                    alignment: Alignment.bottomRight,
                    image: image
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}