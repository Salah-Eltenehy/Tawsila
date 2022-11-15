import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/signup/cubit/SignUpProvider.dart';
import 'package:tawsila/modules/signup/cubit/SignUpStates.dart';
import 'package:tawsila/shared/components/Components.dart';

class SignUpScreen extends StatelessWidget {
  final String language;
  
  SignUpScreen({super.key, required this.language});
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var cityController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => SignUpProvider()..setLanguage(l: language)..readJson(),
      child: BlocConsumer<SignUpProvider, SignUpStates>( 
        listener: (context, state) {},
        builder: (context, state) {
          var signUpCubit = SignUpProvider.get(context);
          return Scaffold(
            body: SingleChildScrollView( 
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "${signUpCubit.items['title1']??'error'}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.black
                      ),
                      ),
                      Text(
                      "${signUpCubit.items['title2']??'error'}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey
                      ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                      children: [
                        defaultTextFormFieldRow(
                          controller: fNameController,
                          textInputType: TextInputType.name,
                          validatorFunction: (value) {
                            if(value.length == 0)
                              return signUpCubit.items['nameError']??"Error";
                          },
                          labelText: signUpCubit.items['Fname']??"Error"
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        defaultTextFormFieldRow(
                          controller: lNameController,
                          textInputType: TextInputType.name,
                          validatorFunction: (value) {
                            if(value.length == 0)
                              return signUpCubit.items['nameError']??"Error";
                          },
                          labelText: signUpCubit.items['Lname']??"Error"
                        ),
                      ],
                    ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultTextFormFieldColumn(
                        controller: emailController, 
                        labelText: signUpCubit.items['email']??"Error", 
                        validatorFunction: (value) {
                          if(value.length == 0)
                            return signUpCubit.items['emailError']??"Error";
                        }, 
                        textInputType: TextInputType.emailAddress
                        ),  
                      SizedBox(
                        height: 20,
                      ),
                      defaultTextFormFieldColumn(
                        controller: passwordController, 
                        labelText: signUpCubit.items['password']??"Error", 
                        validatorFunction: (value) {
                          if(value.length == 0)
                            return signUpCubit.items['passwordError']??"Error";
                        }, 
                        textInputType: TextInputType.text,
                        isSecure: signUpCubit.passwordIsSecure,
                        suffixIcon: signUpCubit.passwordIsSecure ? Icons.visibility_off : Icons.visibility,
                        suffixIconFunction: () {
                          signUpCubit.changePasswordVisibility();
                        }
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultTextFormFieldColumn(
                        controller: confirmPasswordController,
                        labelText: signUpCubit.items['confirmPassword']??"Error", 
                        validatorFunction: (value) {
                          if(value  != passwordController.text)
                            return signUpCubit.items['confirmPasswordError']??"Error";
                        }, 
                        textInputType: TextInputType.text,
                        isSecure: signUpCubit.confirmPasswordIsSecure,
                        suffixIcon: signUpCubit.confirmPasswordIsSecure ? Icons.visibility_off : Icons.visibility,
                        suffixIconFunction: () {
                          signUpCubit.changeConfirmPasswordVisibility();
                        }
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultTextFormFieldColumn(
                        controller: cityController, 
                        labelText: signUpCubit.items['city']??"Error", 
                        validatorFunction: (value) {
                          if(value.length == 0)
                            return signUpCubit.items['cityError']??"Error";
                        }, 
                        textInputType: TextInputType.text
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultTextFormFieldColumn(
                        controller: phoneController, 
                        labelText: signUpCubit.items['phone']??"Error", 
                        validatorFunction: (value){
                          //+201021890205
                          if(value.length != 13)
                            return signUpCubit.items['phoneError']??"Error";
                        }, 
                        textInputType: TextInputType.phone
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      CheckboxListTile(
                        title: Text(
                          "${signUpCubit.items['whatsappCheckBox']??"Error"}"
                        ),
                        value: signUpCubit.hasWhatsApp, 
                        onChanged: (value) {
                          signUpCubit.hasWhatsAppFun();
                        },
                        
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      CheckboxListTile(
                        title: Text(
                          "${signUpCubit.items['termsAndConditions']??"Error"}"
                        ),
                        value: signUpCubit.termsAndConditions, 
                        onChanged: (value) {
                          signUpCubit.termsAndConditionsFun();
                        }, 
                        
                        ),
                  
                  ],
                ),
              ),
            ),
        );}
      ),
    );
  }
  
}