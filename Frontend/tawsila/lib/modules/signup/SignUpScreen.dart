import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/signup/cubit/SignUpCubit.dart';
import 'package:tawsila/modules/signup/cubit/SignUpStates.dart';
import 'package:tawsila/shared/components/Components.dart';

class SignUpScreen extends StatelessWidget {
  String language;
  SignUpScreen({super.key, required this.language});
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var cityController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => SignUpCubit()..setLanguage(l: language)..readJson(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var signUpCubit = SignUpCubit.get(context);
          phoneController.text = "+2";
          return Scaffold(
            body: Directionality(
              textDirection: signUpCubit.language == "English" ? TextDirection.ltr: TextDirection.rtl,
              child: Form(
                key: formKey,
                child: SingleChildScrollView( 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          "${signUpCubit.items['title1']??''}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.black
                          ),
                          ),
                        Text(
                          "${signUpCubit.items['title2']??''}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey
                          ),
                          ),
                        const SizedBox(
                            height: 30,
                          ),
                        Row(
                          children: [
                            defaultTextFormFieldRow(
                              prefixIcon: Icon(Icons.text_fields),
                              controller: fNameController,
                              textInputType: TextInputType.name,
                              validatorFunction: (value) {
                                if(value.length == 0)
                                  return signUpCubit.items['nameError']??"";
                              },
                              labelText: signUpCubit.items['Fname']??""
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            defaultTextFormFieldRow(
                              prefixIcon: Icon(Icons.text_fields),
                              controller: lNameController,
                              textInputType: TextInputType.name,
                              validatorFunction: (value) {
                                if(value.length == 0)
                                  return signUpCubit.items['nameError']??"";
                              },
                              labelText: signUpCubit.items['Lname']??""
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 20,
                          ),
                        defaultTextFormFieldColumn(
                          prefixIcon: Icon(Icons.email),
                            controller: emailController, 
                            labelText: signUpCubit.items['email']??"", 
                            validatorFunction: (value) {
                              if(value.length == 0) {
                                return signUpCubit.items['emailError']??"";
                              }
                            }, 
                            textInputType: TextInputType.emailAddress
                            ),  
                        const SizedBox(
                            height: 20,
                          ),
                        defaultTextFormFieldColumn(
                            prefixIcon: signUpCubit.passwordIsSecure ? Icon(Icons.lock): Icon(Icons.lock_open),
                            controller: passwordController, 
                            labelText: signUpCubit.items['password']??"", 
                            validatorFunction: (value) {
                              if(value.length == 0) {
                                return signUpCubit.items['passwordError']??"";
                              }
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
                        defaultTextFormFieldColumn(
                            prefixIcon: signUpCubit.passwordIsSecure ? Icon(Icons.lock): Icon(Icons.lock_open),
                            controller: confirmPasswordController,
                            labelText: signUpCubit.items['confirmPassword']??"", 
                            validatorFunction: (value) {
                              if(value  != passwordController.text) {
                                return signUpCubit.items['confirmPasswordError']??"";
                              }
                            }, 
                            textInputType: TextInputType.text,
                            isSecure: signUpCubit.confirmPasswordIsSecure,
                            suffixIcon: signUpCubit.confirmPasswordIsSecure ? Icons.visibility_off : Icons.visibility,
                            suffixIconFunction: () {
                              signUpCubit.changeConfirmPasswordVisibility();
                            }
                            ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultTextFormFieldColumn(
                          prefixIcon: Icon(Icons.location_city),
                          controller: cityController, 
                          labelText: signUpCubit.items['city']??"", 
                          validatorFunction: (value) {
                            if(value.length == 0) {
                              return signUpCubit.items['cityError']??"";
                            }
                          }, 
                          textInputType: TextInputType.text
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultTextFormFieldColumn(
                          prefixIcon: Icon(Icons.phone),
                          controller: phoneController, 
                          labelText: signUpCubit.items['phone']??"", 
                          validatorFunction: (value){
                            //+201021890205
                            if(value.length != 13) {
                              return signUpCubit.items['phoneError']??"";
                            }
                          }, 
                          textInputType: TextInputType.phone
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: signUpCubit.hasWhatsAppColor
                            )
                          ),
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              "${signUpCubit.items['whatsappCheckBox']??""}"
                            ),
                            value: signUpCubit.hasWhatsApp, 
                            onChanged: (value) {
                              signUpCubit.hasWhatsAppFun();
                            },
                            ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: signUpCubit.agreeColor
                            )
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: CheckboxListTile(                         
                                      controlAffinity: ListTileControlAffinity.leading,
                                      title: Text(
                                        "${signUpCubit.items['termsAndConditions']??""}"
                                      ),
                                      value: signUpCubit.termsAndConditions, 
                                      onChanged: (value) {
                                        signUpCubit.termsAndConditionsFun();
                                      }, 
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start, 
                                  children: [
                                    TextButton(
                                      onPressed: (){
                                      }, 
                                      child: Text(
                                        "${signUpCubit.items['termsAndConditionsPage']??""}",
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),     
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if(!signUpCubit.hasWhatsApp) {
                              signUpCubit.changeHasWhatsApp();
                              return;
                            }

                            if(!signUpCubit.termsAndConditions) {
                              signUpCubit.agreeTermsAndConditionsColor();
                              return;
                            }

                            if(formKey.currentState!.validate()) {
                              print("ALL RIGHT");
                              // signUpCubit.userSignUp(
                              //     name: "${fNameController.text} ${lNameController.text}",
                              //     email: emailController.text,
                              //     password: passwordController.text,
                              //     phone: phoneController.text
                              // );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "${signUpCubit.items['signUp']??""}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        );}
      ),
    );
  }
}