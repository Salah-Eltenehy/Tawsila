import 'package:flutter/material.dart';
import 'package:tawsila/modules/log-in/SignInScreen.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:tawsila/shared/network/local/Cachhelper.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';
import 'package:toast/toast.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool isSecurePassword = true;
  bool isSecureConfirm = true;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset password"),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            const Text(""),
            const Spacer(),
            TextButton(
              onPressed: () async{
                if (formKey.currentState!.validate()) {
                  String token = await CachHelper.getData(key: 'token');
                  DioHelper.postDataVer(
                      url: 'users/recover/reset-password',
                      token: token,
                      data: {
                        "password": passwordController.text
                      }
                  ).then((value) {
                    ToastContext toastContext = ToastContext();
                    toastContext.init(context);
                    Toast.show(
                        "Successful",
                        duration: Toast.lengthShort,
                        gravity: Toast.bottom,
                        backgroundColor: Colors.green
                    );
                    navigateAndFinish(context: context, screen: SignInScreen(language: "English"));
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
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              defaultTextFormFieldColumn(
                  prefixIcon: isSecurePassword ? const Icon(Icons.lock): const Icon(Icons.lock_open),
                  controller: passwordController,
                  labelText: "Reset Password",
                  validatorFunction: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 8) {
                      return "Password should be > 7";
                    }
                  },
                  textInputType: TextInputType.text,
                  isSecure: isSecurePassword,
                  suffixIcon: isSecurePassword ? Icons.visibility_off : Icons.visibility,
                  suffixIconFunction: () {
                    setState(() {
                      isSecurePassword = !isSecurePassword;
                    });
                  }
              ),
              const SizedBox(height: 20,),
              defaultTextFormFieldColumn(
                  prefixIcon: isSecureConfirm ? const Icon(Icons.lock): const Icon(Icons.lock_open),
                  controller: confirmPasswordController,
                  labelText: "Reset Password",
                  validatorFunction: (value) {
                    if (value != passwordController.text) {
                      return "Passwords are not identical";
                    }

                  },
                  textInputType: TextInputType.text,
                  isSecure: isSecureConfirm,
                  suffixIcon: isSecureConfirm ? Icons.visibility_off : Icons.visibility,
                  suffixIconFunction: () {
                    setState(() {
                      isSecureConfirm = !isSecureConfirm;
                    });
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*

 */
