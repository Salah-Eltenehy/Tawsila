import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:location/location.dart';
import 'package:location/location.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:tawsila/modules/home-page/Cubit/Cubit.dart';
import 'package:tawsila/modules/home-page/Cubit/CubitStates.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';

import '../../shared/components/Components.dart';

class MapScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomePageCubit()..setLanguage(l: "")..getPrevLocation(),
      child: BlocConsumer<HomePageCubit, HomePageStates>( 
        listener: ((context, state) {}),
        builder:(context, state) {
          // HomePageCubit.get(context).getLocation();
          var mapCubit = HomePageCubit.get(context);
          return Scaffold(
            body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: OpenStreetMapSearchAndPick(
                    center: LatLong(mapCubit.userCurrentLatitude!,mapCubit.userCurrentLongtidue!),
                    buttonColor: Colors.blue,
                    buttonText: 'Set Location',
                    onPicked: (pickedData) {
                      mapCubit.getPrevLocation();
                      CachHelper.saveData(key: 'latitude' , value: pickedData.latLong.latitude);
                      CachHelper.saveData(key: 'longitude' , value: pickedData.latLong.longitude);
                      HomePageCubit.get(context).setMapLocation(latitude: pickedData.latLong.latitude, longitude: pickedData.latLong.longitude);
                      print('returned location: lat: ${ HomePageCubit.get(context).userLocationLatidue} long: ${ HomePageCubit.get(context).userLocationLongitude}');
                      Navigator.pop(context);
                    }
                  ),
                ),
          );
        } ),
    );
  }

}
