
import 'package:flutter/material.dart';
import 'package:tawsila/modules/on-boarding/OnBoardingScreen.dart';
import 'package:tawsila/shared/components/Components.dart';

class ChooseLanguage extends StatefulWidget {
  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  String language = "English";
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 60),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                          "Choose Language / إختار لغتك",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      navigateAndFinish(context: context, screen: const OnBoardingScreen(language: "English"));
                    },
                    child:Container(
                      width: double.infinity,
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "English",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(""),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      navigateAndFinish(context: context, screen: const OnBoardingScreen(language: "العربية"));
                    },
                    child: Row(
                      children: const [
                        Text(""),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "العربية",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
    );
  }
}
