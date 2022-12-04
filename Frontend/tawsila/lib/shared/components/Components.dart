import 'package:flutter/material.dart';

Widget defaultTextFormFieldRow({
  required TextEditingController controller,
  required String labelText ,
  required Function validatorFunction,
  required TextInputType textInputType,
  Function? suffixIconFunction,
  Icon? prefixIcon ,
  IconData? suffixIcon,
  bool isSecure = false,
}) =>
    Expanded(
      child: Container( // email address
        height: 50.0,
        child: TextFormField(
          validator: (value) {
            return validatorFunction(value);
          },
          obscureText: isSecure,
          controller: controller,
          keyboardType: textInputType,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
            prefix: Padding(
              padding: const EdgeInsets.all(8.0),
              child: prefixIcon,
            ),
            suffixIcon: IconButton(
              icon: Icon(suffixIcon),
              onPressed: () {
                return suffixIconFunction!();
              },
            ),
          ),
        ),
      ),
    )
;

Widget defaultTextFormFieldColumn({
  required TextEditingController controller,
  required String labelText ,
  required Function validatorFunction,
  required TextInputType textInputType,
  Function? suffixIconFunction,
  Icon? prefixIcon ,
  IconData? suffixIcon,
  bool isSecure = false,
}) =>
    Container( // email address
      height: 50.0,
      color: Colors.white,
      child: TextFormField(
        validator: (value) {
          return validatorFunction(value);
        },
        obscureText: isSecure,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          prefix: Padding(
            padding: const EdgeInsets.all(8.0),
            child: prefixIcon,
          ),
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: () {
              return suffixIconFunction!();
            },
          ),
        ),
      ),
    )
;

void navigateTo ({
  required BuildContext context,
  required Widget screen
}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>  screen
      )
  );
}

void navigateToAndFinish(
    {
      required BuildContext context,
      required Widget screen
    }
    ) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => screen),
          (route) => false);
}