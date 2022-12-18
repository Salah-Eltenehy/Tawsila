// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tawsila/modules/on-boarding/cubit/OnBoardingStates.dart';
import 'package:tawsila/modules/signup/SignUpScreen.dart';
import 'package:tawsila/shared/components/Components.dart';

import '../log-in/SignInScreen.dart';
import '../signup/cubit/SignUpCubit.dart';
import 'cubit/OnBoardingCubit.dart';


class BoardingModel {
  final String image;
  final String title1;
  final String title2;
  final String title3;
  final String title4;
  final String title5;
  final String title6;

  BoardingModel({
    required this.title1,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.title5,
    required this.title6,
    required this.image,
  });
}

class OnBoardingScreen extends StatefulWidget {
  final language;

  const OnBoardingScreen({super.key, required this.language});
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState( language: language);
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  String language;
  _OnBoardingScreenState({required this.language});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  var boardController = PageController();
  List<BoardingModel> lang(){
    List<BoardingModel> boarding;
    language=="English"? boarding = [
      BoardingModel(
          title1: "Rent",
          title2: "Cars",
          title3: "From",
          title4: "Their",
          title5: "Owners",
          title6: "Directly",
          image: "assets/images/1.png"
      ),
      BoardingModel(
          title1: "Make",
          title2: "Money",
          title3: "Out Of",
          title4: "Your",
          title5: "Spare",
          title6: "Cars",
          image: "assets/images/2.png"
      ),
    ]:
    boarding = [
    BoardingModel(
    title1: "استأجر",
    title2: "سيارات",
    title3: "من",
    title4: "مالكهم",
    title5: "مباشرة",
    title6: "",
    image: "assets/images/1.png"
    ),
    BoardingModel(
    title1: "اجني",
    title2: "ربحا",
    title3: "من",
    title4: "سيارتك",
    title5: "الغير",
    title6: "مستهلكه",
    image: "assets/images/2.png"
    ),
    ];
    return boarding;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == "English"? TextDirection.ltr: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => OnBoardingCubit()..setLanguage(l: language)..readJson(),
        child: BlocConsumer<OnBoardingCubit, OnBoardingStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var boarding = lang();
              var onBoardingCubit = OnBoardingCubit.get(context);
            return Scaffold(
              body: Container(
                color: Colors.black,
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: boardController,
                  itemBuilder: (context, index) =>
                      buildBoardingItem(boarding[index],boarding,onBoardingCubit),
                  itemCount: boarding.length,
                ),
              ),
            );
          }
        ),
      ),
    );
  }
  Widget buildBoardingItem(BoardingModel model,var boarding,var onBoardingCubit) => Stack(
    children:
    [
      Image(
        width: double.infinity,
        height: double.infinity,
        image: AssetImage("${model.image}"),
        fit: BoxFit.cover,
      ),
      Container(
        // alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25,),
              Text(
                '${model.title1}',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              Text(
                '${model.title2}',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              Text(
                '${model.title3}',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              Text(
                '${model.title4}',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              Text(
                '${model.title5}',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              Text(
                '${model.title6}',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
      Column(
        children: [
          Expanded(child: Text("")),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: boardController,
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blue,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5.0,
                    ),
                    count: boarding.length,
                  ),
                  const SizedBox(height: 5,),
                  buildButton(
                      color: Colors.white,
                      title: "${onBoardingCubit.items['create']??''}",
                      titleColor: Colors.black,
                      function: () {
                        navigateTo(context: context, screen: SignUpScreen(language: language));
                      }),
                  SizedBox(height: 5,),
                  buildButton(
                      color: Colors.blue,
                      title: "${onBoardingCubit.items['login']??''}",
                      titleColor: Colors.white,
                      function: () {
                        navigateAndFinish(context: context, screen: SignInScreen(language: language));
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    ],

  );
  Widget buildButton(
      {
        required color,
        required title,
        required titleColor,
        required function
      }

      ) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Center(
          child: Text(
            "${title}",
            style: TextStyle(
                color: titleColor
            ),
          ),
        ),
      ),
    );
  }
}
