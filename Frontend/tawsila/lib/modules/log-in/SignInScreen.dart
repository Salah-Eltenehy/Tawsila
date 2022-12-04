import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/signup/cubit/SignUpProvider.dart';
import 'package:tawsila/modules/signup/cubit/SignUpStates.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatelessWidget{

  final String language;      //hold the language of the program(arabic-english)

  SignInScreen({super.key, required this.language});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (context) => SignUpProvider()..setLanguage(l:language)..readJson(), //get list of items with the right words for current languages

      child: BlocConsumer<SignUpProvider, SignUpStates>(
        listener: (context, state){},
        builder: (context, state){
          var signUpCubit = SignUpProvider.get(context);

          //the main view of the signIn screen
          return Scaffold(
            backgroundColor: Colors.grey[300],  //color of the page background
            body: Directionality(
              textDirection: signUpCubit.language == "English" ? TextDirection.ltr: TextDirection.rtl,  //determine how to start writing (left to right or the opposite) ,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,  //center all the widget in the screen
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Text(
                            "${signUpCubit.items['hey']??'error'}",
                            style:GoogleFonts.lato(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,

                            ),
                          ),

                        ],),

                      Text(
                        "${signUpCubit.items['welcome2']??""}",
                        style:GoogleFonts.dancingScript(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10,),

                      defaultTextFormFieldColumn(
                          controller: emailController,
                          textInputType: TextInputType.emailAddress,
                          validatorFunction: (value) {
                            if(!(value.toString().contains('@')))
                              {return "${signUpCubit.items['emailError']??'error'}";}
                          },
                          labelText: "${signUpCubit.items['email']??'error'}"
                      ),

                      const SizedBox(height: 20,),
                      defaultTextFormFieldColumn(
                          controller: passwordController,
                          labelText: "${signUpCubit.items['password']??'error'}",
                          validatorFunction: (value, realValue) {
                            if(value != realValue)
                              {return "${signUpCubit.items['passwordError']??'error'}";}
                          },
                          textInputType: TextInputType.text,
                          isSecure: signUpCubit.passwordIsSecure,
                          suffixIcon: signUpCubit.passwordIsSecure ? Icons.visibility_off : Icons.visibility,
                          suffixIconFunction: () {
                            signUpCubit.changePasswordVisibility();
                          }
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          child: Text(
                            "${signUpCubit.items['signIn']??"Error"}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {print("ALL Done");},
                        ),
                      ),

                      const SizedBox(height: 20,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Row(
                              children: [
                                Text(
                                  "${signUpCubit.items['doNotHaveAnAccount']??""}",
                                ),

                                TextButton(onPressed: (){},
                                    child: Text(
                                        "${signUpCubit.items['registerNow']??""}",
                                      style: TextStyle(color: Colors.blue),
                                    ),)
                              ],
                            ),
                          ),
                        ],
                      )
                    ]
                ),
              ),
            ),
          );
        },
      ),
    );

  }

}