import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../signup/cubit/SignUpCubit.dart';
import '../signup/cubit/SignUpStates.dart';



class Verification extends StatelessWidget{
  final String language;
  const Verification({super.key, required this.language});
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
              const Image( height: 200,width: 300,
                image: AssetImage('assets/images/verify.png')),
              Text(
                "${signUpCubit.items['verify']??''}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                  color: Colors.black
                ),),
              Text(
              "${signUpCubit.items['info']??''}",
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
              height: 70,
              width: 70,
              child: TextFormField(
                onChanged: (value){
                  if(value.length == 1) {
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
            )
          ],
        ),]
    ));}));
  }

}