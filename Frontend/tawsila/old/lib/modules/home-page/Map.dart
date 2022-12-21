import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:location/location.dart';
import 'package:location/location.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:tawsila/modules/home-page/Cubit/Cubit.dart';
import 'package:tawsila/modules/home-page/Cubit/CubitStates.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';
/*
 */
import '../../shared/components/Components.dart';

class MapScreen extends StatelessWidget {

  double userCurrentLatitude = 10;

  double userCurrentLongtidue = 20;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomePageCubit()..getPrevLocation(),
      child: BlocConsumer<HomePageCubit, HomePageStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var homePageCubit = HomePageCubit.get(context);
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: OpenStreetMapSearchAndPick(
                  center: LatLong(homePageCubit.userCurrentLatitude??20,homePageCubit.userCurrentLongtidue??20),
                  buttonColor: Colors.blue,
                  buttonText: 'Set Location',
                  onPicked: (pickedData) {
                    CachHelper.saveData(key: 'latitude' , value: pickedData.latLong.latitude);
                    CachHelper.saveData(key: 'longitude' , value: pickedData.latLong.longitude);
                    Navigator.pop(context);
                  }
              ),
            ),
          );
        },
      ),
    );

  }
}