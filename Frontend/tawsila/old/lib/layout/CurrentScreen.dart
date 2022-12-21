import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/layout/cubit/AppStates.dart';
import 'package:tawsila/modules/on-boarding/OnBoardingScreen.dart';
import 'package:tawsila/modules/signup/SignUpScreen.dart';

import '../shared/components/Components.dart';
import 'cubit/AppProvider.dart';

class CurrentScreen extends StatelessWidget {
  List<DropdownMenuItem> items = [
    DropdownMenuItem(child: Text("English"), value: 'English',),
    DropdownMenuItem(child: Text("العربية"), value: 'العربية',),
  ];

  
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
                        screen: OnBoardingScreen(language: "English"));
                      }),
              ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                

              ]
            )
          );
        },
        ),
      );
  }

}