import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/layout/cubit/AppProvider.dart';
import 'package:tawsila/layout/cubit/AppStates.dart';
import 'package:tawsila/shared/bloc_observer.dart';

import 'layout/CurrentScreen.dart';

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  
  Bloc.observer = MyBlocObserver();
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
      home: CurrentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
