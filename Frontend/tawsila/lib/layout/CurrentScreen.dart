import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/layout/cubit/AppStates.dart';
import 'package:tawsila/modules/log-in/SignInScreen.dart';
import 'package:tawsila/modules/signup/SignUpScreen.dart';
import '../shared/components/Components.dart';
import 'cubit/AppProvider.dart';


class CurrentScreen extends StatelessWidget {
  List<DropdownMenuItem> items = const[
    DropdownMenuItem(value: 'English',child: Text("English"),),
    DropdownMenuItem(value: 'العربية',child: Text("العربية"),),
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
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Column(
                              children: [
                                TextButton(
                                    child: const Text(
                                      "Sign-in",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      ),

                                    ),
                                    onPressed: () {
                                      navigateTo(
                                          context: context,
                                          screen: SignInScreen(language: currentCubit.dropDownValue));
                                    }),

                                SizedBox(height: 10,
                                child: Container(
                                  height: 10,
                                  color: Colors.white,
                                ),),

                                TextButton(
                                  child: const Text(
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
                                    screen: SignUpScreen(language: currentCubit.dropDownValue));
                                }),
                              ])
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),
                  ]
              )
          );
        },
      ),
    );
  }
}