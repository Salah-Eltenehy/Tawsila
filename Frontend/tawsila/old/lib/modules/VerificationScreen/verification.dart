import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/home-page/HomePage.dart';
import 'package:tawsila/shared/components/Components.dart';

import '../signup/cubit/SignUpCubit.dart';
import '../signup/cubit/SignUpStates.dart';



class Verification extends StatelessWidget{
  final String language;
  String res = "ffffff";
  Verification({super.key, required this.language});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignUpCubit()..setLanguage(l: language)..readJson('verify'),
        child: BlocConsumer<SignUpCubit, SignUpStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var signUpCubit = SignUpCubit.get(context);
              return Scaffold(
                  body: Column(
                    children: [
                      SizedBox(height: 40,),
                      const Image( height: 200,width: 300,
                          image: AssetImage('assets/images/verify.png')),
                      Text(
                        "${signUpCubit.items['verify']??'error'}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 60,
                            color: Colors.black
                        ),),
                      Text(
                        "${signUpCubit.items['info']??'error'}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black
                        ),),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: TextFormField(
                              onChanged: (value){
                                if(value.length == 1) {
                                  res = replaceCharAt(res, 0, value);
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              decoration: const InputDecoration(hintText: "-"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],

                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: TextFormField(
                              onChanged: (value){
                                if(value.length == 1) {
                                  res = replaceCharAt(res, 1, value);
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              decoration: const InputDecoration(hintText: "-"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],

                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: TextFormField(
                              onChanged: (value){
                                if(value.length == 1) {
                                  res = replaceCharAt(res, 2, value);
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              decoration: const InputDecoration(hintText: "-"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],

                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: TextFormField(
                              onChanged: (value){
                                if(value.length == 1) {
                                  res = replaceCharAt(res, 3, value);
                                  FocusScope.of(context).nextFocus();
                                }
                              },

                              decoration: const InputDecoration(hintText: "-"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],

                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: TextFormField(
                              onChanged: (value){
                                if(value.length == 1) {
                                  res = replaceCharAt(res, 4, value);
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              decoration: const InputDecoration(hintText: "-"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],

                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: TextFormField(
                              onChanged: (value){
                                if(value.length == 1) {
                                  res = replaceCharAt(res, 5, value);

                                  if(!res.contains("f")) {
                                    navigateAndFinish(context: context, screen: HomePageScreen(language: language));
                                  }
                                }
                              },

                              decoration: const InputDecoration(hintText: "-"),
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],

                            ),
                          )
                        ],
                      ),TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {},
                        child: Text("${signUpCubit.items['resend']??''}",),

                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 80,
                        height: 40,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          child: Text(
                            "${signUpCubit.items['enter']??""}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            if(!res.contains("f")) {
                              navigateAndFinish(context: context, screen: HomePageScreen(language: language));
                            }
                          },
                        ),
                      ),
                    ],

                  ));}));
  }
  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

}



