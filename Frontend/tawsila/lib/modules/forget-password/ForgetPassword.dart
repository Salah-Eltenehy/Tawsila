import 'package:flutter/material.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';
import 'package:toast/toast.dart';

class ForgetPasswordScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  ToastContext toastContext = ToastContext();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          children: [
            const Text(""),
            const Spacer(),
            TextButton(
                onPressed: () {
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
                },
                child: Container(
                  height: 60,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),
                    ),
                  ),
                ),
            )
          ],
        ),
      ],
      appBar: AppBar(),
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
