import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePageScreen extends StatefulWidget {
  final language;

  const HomePageScreen({super.key, required this.language});
  
  @override
  State<HomePageScreen> createState() => _HomePageScreenState(language);
}

class _HomePageScreenState extends State<HomePageScreen> {
  final language;
  var items = {};
  var rentCarPeriodController = TextEditingController();
  var addressOfPicupController = TextEditingController();
  _HomePageScreenState(this.language) {
    readJson();
  }
    void readJson() async{
    items = {};
    String fileName = language == "English"? "english": "arabic";
    print(fileName);
    final String response = await rootBundle.loadString('assets/languages/${fileName}.json');
    final data = await json.decode(response);
    items = data['HomePage'];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${items['title']}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              print("User page");
            },
            child: CircleAvatar(
              child: Image(
                image: AssetImage('assets/iamges/owner.png'),
              ),
            ),
          ),
        ]
      ),
      body: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  print("Offer car page");
                },
                child: Expanded(
                  child: Container(
                    height: 120,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${items['offerCar1']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${items['offerCar2']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Image(
                          image: AssetImage('assets/iamges/car.png')
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  print("Offer car page");
                },
                child: Expanded(
                  child: Container(
                    height: 120,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${items['offers1']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${items['offers2']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Image(
                          image: AssetImage('assets/iamges/label.png')
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '${items['RentCar']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '${items['RentalPeriod']}'
          ),
          buildTextField(controller: rentCarPeriodController, placeHolder: items['RentalPeriodHint']),
          Text('${items['AddressOfPickup']}'),
          buildTextField(controller: addressOfPicupController, placeHolder: items['AddressOfPickupHint']),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String placeHolder
  }) {
    return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.black
              )
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '${placeHolder}'
              ),
            ),
          );
  }
}