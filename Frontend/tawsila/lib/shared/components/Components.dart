

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../network/local/Cachhelper.dart';

class UserLocation {
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
    print("LOCATION");
    print("LATITUDE: ${locationData.latitude}");
    print("LONGTIUDE: ${locationData.longitude}");
    // await location.getLocation().then((value) => locationData = value);
    CachHelper.saveData(key: 'latitude', value: locationData.latitude);
    CachHelper.saveData(key: 'longitude', value: locationData.longitude);
    double d1 = await CachHelper.getData(key: "latitude") as double;
    double d2 = await CachHelper.getData(key: "longitude") as double;
    print("LATITUDE: ${d1}");
    print("LONGTIUDE: ${d2}");
    print("DONNNNNNNNNNNNNNNNNNNNNNNNNE");
  }
}
Widget defaultTextFormFieldRow({
          required TextEditingController controller,
          required String labelText ,
          required Function validatorFunction,
          required TextInputType textInputType,
          Function? suffixIconFunction,
          Icon? prefixIcon ,
          IconData? suffixIcon,
          bool isSecure = false,
          }) => 
              Expanded( 
                child: Container( // email address
                height: 50.0,
                child: TextFormField(
                  validator: (value) {
                    return validatorFunction(value);
                  },
                  obscureText: isSecure,
                  controller: controller,
                  keyboardType: textInputType,
                  
                  decoration: InputDecoration(
                      
                    labelText: labelText,
                    border: OutlineInputBorder(),
                    prefix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: prefixIcon,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(suffixIcon),
                      onPressed: () {
                        return suffixIconFunction!();
                      },
                    ),
                  ),
                ),
                          ),
              )
            ;

Widget defaultTextFormFieldColumn({
          required TextEditingController controller,
          required String labelText ,
          required Function validatorFunction,
          required TextInputType textInputType,
          Function? suffixIconFunction,
          Icon? prefixIcon ,
          IconData? suffixIcon,
          bool isSecure = false,
          }) => 
              Container( // email address
              height: 50.0,
              child: TextFormField(
                validator: (value) {
                  return validatorFunction(value);
                },
                obscureText: isSecure,
                controller: controller,
                keyboardType: textInputType,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: OutlineInputBorder(),
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: prefixIcon,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: () {
                      return suffixIconFunction!();
                    },
                  ),
                ),
              ),
                        )
            ;

void navigateTo ({
  required BuildContext context,
  required Widget screen
}) {
   Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  screen
      )
    );
}

void navigateToAndFinish(
  {
    required BuildContext context,
    required Widget screen
  }
) {
  Navigator.pushAndRemoveUntil(
    context, 
    MaterialPageRoute(
      builder: (context) => screen), 
    (route) => false);
}
