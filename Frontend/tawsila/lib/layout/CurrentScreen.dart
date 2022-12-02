import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/layout/cubit/AppStates.dart';
import 'package:tawsila/modules/home-page/HomePage.dart';

import '../shared/components/Components.dart';
import 'cubit/AppProvider.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentScreen extends StatelessWidget {
  List<DropdownMenuItem> items = [
    DropdownMenuItem(child: Text("English"), value: 'English',),
    DropdownMenuItem(child: Text("العربية"), value: 'العربية',),
  ];
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TawsilaMainProvider(),
      child: BlocConsumer<TawsilaMainProvider, TawsilaStates>(
        listener: (context, state) {},
        builder:  (context, state) {
          var currentCubit = TawsilaMainProvider.get(context);
          return Scaffold(
            appBar: AppBar(
              actions: [
                  DropdownButton(
                    items: items, 
                    value: currentCubit.dropDownValue,
                    onChanged: (value) {
                      value =="English"? currentCubit.changeLanguage(isEn: true):currentCubit.changeLanguage(isEn: false); 
                    }),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Center(
                    child: TextButton(
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
              
                        ),
                      onPressed: () {
                        navigateTo(
                        context: context, 
                        screen: HomePageScreen(language: currentCubit.dropDownValue));
                      }),
              ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ]
            ),
          );
        },
        ),
      );
  }

}
/*
 Container(
              width: 200,
              height: 200,
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              )
            )
*/
/*
Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Center(
                    child: TextButton(
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
              
                        ),
                      onPressed: () {
                        navigateTo(
                        context: context, 
                        screen: HomePageScreen(language: currentCubit.dropDownValue));
                      }),
              ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ]
            )
*/