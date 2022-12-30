import 'package:flutter/material.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';
import 'package:toast/toast.dart';

import '../VerificationScreen/verification.dart';

class ForgetPasswordScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  ToastContext toastContext = ToastContext();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
        radius: 30,
        child: IconButton(onPressed: () {
          toastContext.init(context);
          if(formKey.currentState!.validate()) {
            DioHelper.postData(
                url: 'users/recover/identify',
                data: {
                  "email": emailController.text
                }
            ).then((value) async {
              Toast.show(
                  "Email valid",
                  duration: Toast.lengthShort,
                  gravity: Toast.bottom,
                  backgroundColor: Colors.green
              );
              await CachHelper.saveData(key: 'token', value: value.data['token']);
              navigateAndFinish(context: context, screen: Verification(language: 'English',reset: true,));
            }).catchError((onError) {
              print(onError.toString());
              Toast.show(
                  "Email Invalid",
                  duration: Toast.lengthShort,
                  gravity: Toast.bottom,
                  backgroundColor: Colors.red
              );
            });
          }
        }, icon: const Icon(Icons.arrow_right_alt_sharp),
        ),
      ),

      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: defaultTextFormFieldColumn(
                controller: emailController,
                labelText: "Email Address",
                validatorFunction: (value) {
                  if (value.isEmpty) {
                    return "Email address is required";
                  }
                },
                textInputType: TextInputType.emailAddress
            ),
          ),
        ),
      ),
    );
  }
}
