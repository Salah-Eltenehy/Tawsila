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

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  UserLocation()..getLocation();
  await CachHelper.init();

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
