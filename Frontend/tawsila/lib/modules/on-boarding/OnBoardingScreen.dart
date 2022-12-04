// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tawsila/modules/signup/SignUpScreen.dart';
import 'package:tawsila/shared/components/Components.dart';


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
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        title1: "Rent",
        title2: "Cars",
        title3: "From",
        title4: "Their",
        title5: "Owners",
        title6: "Directly",
        image: "assets/images/onboarding1."
        // image: "https://media.istockphoto.com/id/1150425295/photo/3d-illustration-of-generic-hatchback-car-perspective-view.jpg?s=612x612&w=0&k=20&c=vws8oDFjcfGpqNAybWPxsA9XROdcBh2MXW2PGEDgk-8="
    ),
    BoardingModel(
        title1: "Make",
        title2: "Money",
        title3: "Out Of",
        title4: "Your",
        title5: "Spare",
        title6: "Cars",
        image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6saz6OGyTvH5ZhHHYdi--qphBUDgqND-pGvjTxv84fA&s"
    ),
  ];

  bool isLast = false;

  // void submit() {
  //   CacheHelper.saveData(
  //     key: 'onBoarding',
  //     value: true,
  //   ).then((value)
  //   {
  //     if (value) {
  //       navigateAndFinish(
  //         context,
  //         ShopLoginScreen(),
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                print("SKIP");
              },
              child: Text("SKIP", style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Container(
        color: Colors.black,
        child: PageView.builder(
          physics: BouncingScrollPhysics(),
          controller: boardController,
          onPageChanged: (int index) {
            if (index == boarding.length - 1) {
              setState(() {
                isLast = true;
              });
            } else {
              setState(() {
                isLast = false;
              });
            }
          },
          itemBuilder: (context, index) =>
              buildBoardingItem(boarding[index]),
          itemCount: boarding.length,
        ),
      ),
    );
  }
/*
Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5.0,
                  ),
                  count: boarding.length,
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast)
                    {
                      print("HHHHHHHHHHHHHHHHHH");
                    } else {
                      boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        )
 */
  Widget buildBoardingItem(BoardingModel model) => Stack(
    // fit: StackFit.expand,
    children:
       [
         Image(
           image: NetworkImage("${model.image}"),
           fit: BoxFit.cover,
         ),
         Container(
           alignment: Alignment.topLeft,
           child: Padding(
             padding: const EdgeInsets.all(10.0),
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   '${model.title1}',
                   style: TextStyle(
                       fontSize: 24.0,
                       fontWeight: FontWeight.bold,
                       color: Colors.white
                   ),
                 ),
                 Text(
                   '${model.title2}',
                   style: TextStyle(
                       fontSize: 24.0,
                       fontWeight: FontWeight.bold,
                       color: Colors.white
                   ),
                 ),
                 Text(
                   '${model.title3}',
                   style: TextStyle(
                       fontSize: 24.0,
                       fontWeight: FontWeight.bold,
                       color: Colors.white
                   ),
                 ),
                 Text(
                   '${model.title4}',
                   style: TextStyle(
                       fontSize: 24.0,
                       fontWeight: FontWeight.bold,
                       color: Colors.white
                   ),
                 ),
                 Text(
                   '${model.title5}',
                   style: TextStyle(
                       fontSize: 24.0,
                       fontWeight: FontWeight.bold,
                       color: Colors.white
                   ),
                 ),
                 Text(
                   '${model.title6}',
                   style: TextStyle(
                       fontSize: 24.0,
                       fontWeight: FontWeight.bold,
                       color: Colors.white
                   ),
                 ),
               ],
             ),
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(10),
           child: Container(
             alignment: Alignment.bottomCenter,
             child: Column(
               children: [
                 SmoothPageIndicator(
                   controller: boardController,
                   effect: ExpandingDotsEffect(
                     dotColor: Colors.grey,
                     activeDotColor: Colors.blue,
                     dotHeight: 10,
                     expansionFactor: 4,
                     dotWidth: 10,
                     spacing: 5.0,
                   ),
                   count: boarding.length,
                 ),
                 SizedBox(height: 5,),
                 buildButton(
                     color: Colors.white,
                     title: "Create free accout",
                     titleColor: Colors.black,
                     function: () {
                       navigateTo(context: context, screen: SignUpScreen(language: "English"));
                     }),
                 SizedBox(height: 5,),
                 buildButton(
                     color: Colors.blue,
                     title: "Login",
                     titleColor: Colors.white,
                     function: () {
                       print("HERE");
                     })
               ],
             ),
           ),
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

// class OnBoardingScreen extends StatelessWidget {
//   // const OnBoardingScreen({Key? key}) : super(key: key);

//   var boardController = PageController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           TextButton(
//               onPressed: () {
//
//               },
//               child: Text("Skip")
//           ),
//         ],
//       ),
//       body: Expanded(
//         child: PageView.builder(
//             physics: BouncingScrollPhysics(),
//             controller: boardController,
//             itemBuilder: (context, index) => buildBoardingItem(items[index]),
//           itemCount: items.length,
//         ),
//       ),
//     );
//   }
//   Widget buildBoardingItem(BoardingModel model) {
//     return Column(
//       children: [
//         Container(
//           alignment: Alignment.topLeft,
//           child: Text(
//             "${model.title1}",
//             style: TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//               fontWeight: FontWeight.bold
//             ),
//           ),
//         ),
//         // Container(
//         //   alignment: Alignment.topLeft,
//         //   child: Text(
//         //     "${model.title2}",
//         //     style: TextStyle(
//         //         fontSize: 20,
//         //         color: Colors.white,
//         //         fontWeight: FontWeight.bold
//         //     ),
//         //   ),
//         // ),
//         // Container(
//         //   alignment: Alignment.topLeft,
//         //   child: Text(
//         //     "${model.title3}",
//         //     style: TextStyle(
//         //         fontSize: 20,
//         //         color: Colors.white,
//         //         fontWeight: FontWeight.bold
//         //     ),
//         //   ),
//         // ),
//         // Container(
//         //   alignment: Alignment.topLeft,
//         //   child: Text(
//         //     "${model.title4}",
//         //     style: TextStyle(
//         //         fontSize: 20,
//         //         color: Colors.white,
//         //         fontWeight: FontWeight.bold
//         //     ),
//         //   ),
//         // ),
//         // Container(
//         //   alignment: Alignment.topLeft,
//         //   child: Text(
//         //     "${model.title5}",
//         //     style: TextStyle(
//         //         fontSize: 20,
//         //         color: Colors.white,
//         //         fontWeight: FontWeight.bold
//         //     ),
//         //   ),
//         // ),
//         // Container(
//         //   alignment: Alignment.topLeft,
//         //   child: Text(
//         //     "${model.title6}",
//         //     style: TextStyle(
//         //         fontSize: 20,
//         //         color: Colors.white,
//         //         fontWeight: FontWeight.bold
//         //     ),
//         //   ),
//         // ),
//         // Image(image: NetworkImage("${model.image}"), fit: BoxFit.cover,)
//       ],
//     );
//   }
// }
