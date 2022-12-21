import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/layout/cubit/AppProvider.dart';
import 'package:tawsila/layout/cubit/AppStates.dart';
import 'package:tawsila/modules/home-page/HomePage.dart';
import 'package:tawsila/modules/on-boarding/OnBoardingScreen.dart';
import 'package:tawsila/modules/search-result/SearchResultScreen.dart';
import 'package:tawsila/shared/bloc_observer.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';

import 'layout/CurrentScreen.dart';
import 'modules/Language/ChooseLanguage.dart';
import 'modules/filter/FilterScreen.dart';

void main() async {



  WidgetsFlutterBinding.ensureInitialized();
  
  UserLocation()..getLocation();
  await CachHelper.init();
  // String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiMyIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2dpdmVubmFtZSI6IkpvZSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL3N1cm5hbWUiOiJEb2UiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJqb2VAZXhhbXBsZS5jb20iLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9tb2JpbGVwaG9uZSI6IjAwMjAxMTIzNDU2Nzg5IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVmVyaWZpZWRVc2VyIiwibmJmIjoxNjcwMjY2NzMzLCJleHAiOjE2NzAyNzAzMzMsImlzcyI6Imh0dHBzOi8vYXBpLnRhd3NpbGEuY29tIiwiYXVkIjoibW9iaWxlLWFwcCJ9.mJ2Qknav22EU6DtcPRR5GMQZN6gnUjqQ1U6Ab3WBrtM";
  // CachHelper.saveData(key: 'token', value: token);
  //String t = await CachHelper.getData(key: 'token')?? "";
  //Map<String, dynamic> m = parseJwt(t);
  //print(m);
  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tawsila',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                SecondScreen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "TAWSILA",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 50,
              decoration: TextDecoration.none
            ),
          ),
        ),
      ),
    );
  }
}
class SecondScreen extends StatelessWidget {
  @override
  StatefulWidget build(BuildContext context) {
    return MaterialApp(
      title: 'Tawsila',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChooseLanguage(), //ChooseLanguage()
      debugShowCheckedModeBanner: false,
    );
  }
}
