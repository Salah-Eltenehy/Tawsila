import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/layout/cubit/AppProvider.dart';
import 'package:tawsila/layout/cubit/AppStates.dart';
import 'package:tawsila/shared/bloc_observer.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';

import 'layout/CurrentScreen.dart';

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  
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
    Timer(Duration(seconds: 3),
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
    return Container(
      color: Colors.black,
      child: Image( height: 90,width: 90,
          image: AssetImage('assets/images/splash.png')),
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
      home: CurrentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
