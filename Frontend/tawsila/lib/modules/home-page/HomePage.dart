import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/home-page/Cubit/Cubit.dart';
import 'package:tawsila/modules/home-page/Cubit/CubitStates.dart';

class HomePageScreen extends StatelessWidget {
  final language;

  HomePageScreen({super.key, required this.language});
  
  var items = {};

  var rentCarPeriodController = TextEditingController();

  var addressOfPicupController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (BuildContext context) => HomePageCubit()..setLanguage(l: language)..readJson('HomePage'),
      child: BlocConsumer<HomePageCubit , HomePageStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state)
        { var homePageCubit = HomePageCubit.get(context);
          return Scaffold(
          appBar: AppBar(
              title: Text(
                "${homePageCubit.items['title'] ?? ''}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    print("User page");
                  },
                  child: CircleAvatar(
                    child: Image(
                      image: NetworkImage('https://th.bing.com/th/id/OIP.ne2gc0vnnK8CH4r4AJNjFgAAAA?pid=ImgDet&rs=1'),
                    ),
                  ),
                ),
              ]
          ),
          body: Padding(
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
                        print("Offer Car page");
                      }
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
                      }
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
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    homePageCubit.getLocation().then(
                      (value) {
                        homePageCubit.setLocation(value);
                      }
                      );
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: Text(
                      'Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
                Text(
                  "${homePageCubit.locationTTTT!=''? homePageCubit.locationTTTT: 'error'}"
                  ,style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                  ),
              ],
            ),
          ),
        );}
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String placeHolder
  }) {
    return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.black
              )
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '${placeHolder}'
              ),
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
                                          fontSize: 20,
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
                                    width: 140,
                                    height: 140,
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