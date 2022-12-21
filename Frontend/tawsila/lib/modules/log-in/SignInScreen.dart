import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tawsila/modules/home-page/HomePage.dart';
import 'package:tawsila/modules/signup/SignUpScreen.dart';
import 'package:tawsila/modules/signup/cubit/SignUpCubit.dart';
import 'package:tawsila/modules/signup/cubit/SignUpStates.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';
import 'package:toast/toast.dart';

class SignInScreen extends StatelessWidget{

  final String language;      //hold the language of the program(arabic-english)

  SignInScreen({super.key, required this.language});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    ToastContext sss = ToastContext();
    return BlocProvider(
        create: (context) => SignUpCubit()..setLanguage(l:language)..readJson('SignUp'), //get list of items with the right words for current languages
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state){},
        builder: (context, state){
          var signUpCubit = SignUpCubit.get(context);

          //the main view of the signIn screen
          return Scaffold(
            backgroundColor: Colors.grey[300],  //color of the page background
            body: Form(
              key: formKey,
              child: Directionality(
                textDirection: signUpCubit.language == "English" ? TextDirection.ltr: TextDirection.rtl,  //determine how to start writing (left to right or the opposite) ,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,  //center all the widget in the screen
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Row(
                              children: [
                                Text(
                                  "${signUpCubit.items['title1']??''}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.black
                                    ),
                                ),
                                SizedBox(width: 10,),
                                Image(image: AssetImage('assets/images/hand.png'), width: 50, height: 50,)
                              ],
                            ),

                          ],),
                        SizedBox(height: 20,),
                        Text(
                          "${signUpCubit.items['welcome2']??""}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.grey
                            ),
                        ),

                        const SizedBox(height: 10,),

                        defaultTextFormFieldColumn(
                            controller: emailController,
                            prefixIcon: Icon(Icons.email),
                            textInputType: TextInputType.emailAddress,
                            validatorFunction: (String? value) {
                              if(value!.isEmpty)
                                return "${signUpCubit.items['emailErrorEmpty']??''}";
                              else if(!EmailValidator.validate(value, true)) {
                                return "${signUpCubit.items['emailError']??''}";
                              }
                            },
                            labelText: "${signUpCubit.items['email']??''}"
                        ),

                        const SizedBox(height: 20,),
                        defaultTextFormFieldColumn(
                            controller: passwordController,
                            labelText: "${signUpCubit.items['password']??''}",
                            validatorFunction: (String? value) {
                              if(value!.length < 8)
                                {return "${signUpCubit.items['passwordError']??''}";}
                            },
                            prefixIcon: signUpCubit.passwordIsSecure ? Icon(Icons.lock) : Icon(Icons.lock_open),
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
                            onPressed: () {
                              if(formKey.currentState!.validate()) {
                                DioHelper.postData(url: 'Users/LogIn',
                                    data: {'email' : emailController.text,
                                      'password' : passwordController.text}).
                                    then((value){
                                    CachHelper.saveData(key: 'token', value: value.data['token']);
                                    sss.init(context);
                                    Toast.show("Log In Successfully",
                                        duration: Toast.lengthShort,
                                        gravity:  Toast.bottom,backgroundColor: Colors.green);
                                        navigateAndFinish(context: context, screen: HomePageScreen(language: language));
                                        print(value);
                                    }).catchError((error) {
                                    sss.init(context);
                                    Toast.show("Invalid email or password",
                                    duration: Toast.lengthLong,
                                    gravity:  Toast.bottom,backgroundColor: Colors.red);

                                print("#############");
                                });
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 20,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${signUpCubit.items['doNotHaveAnAccount']??""}",
                            ),

                            TextButton(onPressed: (){
                              print("HHHHHHHHHHHHHHHHHHHHHHHHHHH");
                              navigateAndFinish(context: context, screen: SignUpScreen(language: language));
                            },
                                child: Text(
                                    "${signUpCubit.items['registerNow']??""}",
                                  style: TextStyle(color: Colors.blue),
                                ),)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              print("Don't have an account");

                            },
                            child: Text(
                              "${signUpCubit.items['forgetPassword']??''}",
                              style: TextStyle(
                                color: Colors.blue
                              ),
                            )
                        ),
                      ]
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

  }

}