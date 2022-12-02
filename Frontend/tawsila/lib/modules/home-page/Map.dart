import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:tawsila/modules/home-page/Cubit/Cubit.dart';
import 'package:tawsila/modules/home-page/Cubit/CubitStates.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';

class MapScreen extends StatelessWidget {
  double userCurrentLatitude = 0.0;
  double userCurrentLongtidue = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomePageCubit()..setLanguage(l: ""),
      child: BlocConsumer<HomePageCubit, HomePageStates>( 
        listener: ((context, state) {}),
        builder:(context, state) {
          HomePageCubit.get(context).getLocation();
          return Scaffold(
            body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: OpenStreetMapSearchAndPick(
                    center: LatLong(CachHelper.getData(key: 'latitude')??20, CachHelper.getData(key: 'longitude')??20),
                    buttonColor: Colors.blue,
                    buttonText: 'Set Location',
                    onPicked: (pickedData) {
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