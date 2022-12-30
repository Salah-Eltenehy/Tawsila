import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/layout/cubit/AppProvider.dart';
import 'package:tawsila/layout/cubit/AppStates.dart';
import 'package:tawsila/modules/home-page/HomePage.dart';
import 'package:tawsila/modules/log-in/SignInScreen.dart';
import 'package:tawsila/modules/on-boarding/OnBoardingScreen.dart';
import 'package:tawsila/modules/search-result/SearchResultScreen.dart';
import 'package:tawsila/shared/bloc_observer.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:tawsila/shared/end-points.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';

import 'layout/CurrentScreen.dart';
import 'modules/Language/ChooseLanguage.dart';
import 'modules/VerificationScreen/verification.dart';
import 'modules/filter/FilterScreen.dart';
import 'modules/forget-password/ForgetPassword.dart';
import 'modules/forget-password/RestPassword.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserLocation()..getLocation();
  await CachHelper.init();
  // Bloc.observer = MyBlocObserver();
  String token = await CachHelper.getData(key: 'token');
  Map<String, dynamic> tokenInfo = parseJwt(token);
  var screen;
  if (tokenInfo[VERIFYUSER] == "UnverifiedPasswordResetter") {
    screen = Verification(language: 'English', reset: true,);
  } else if (tokenInfo[VERIFYUSER] == "UnverifiedUser") {
    screen = Verification(language: 'English', reset: false,);
  } else if (tokenInfo[VERIFYUSER] == "VerifiedUser"){
    screen = HomePageScreen(language: 'English');
  } else {
    screen = SignInScreen(language: 'English');
  }
  DioHelper.init();

  runApp(MyApp(screen: screen,));
}

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  final screen;

  const MyApp({super.key, required this.screen});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tawsila',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: screen,
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
