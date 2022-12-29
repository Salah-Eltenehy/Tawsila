import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tawsila/modules/car-offer/Cubit/OfferCubit.dart';
import 'package:tawsila/shared/bloc_observer.dart';
import 'package:tawsila/shared/components/Components.dart';
import '../../shared/network/local/Cachhelper.dart';
import '../home-page/HomePage.dart';
import '../home-page/Map.dart';
import 'Cubit/OfferStates.dart';

class CarOfferScreen extends StatelessWidget{

  final String language;      //hold the language of the program(arabic-english)

  CarOfferScreen({super.key, required this.language});

  //Controllers for all text fields in the page
  var brandController = TextEditingController();
  var modelController = TextEditingController();
  var modelYearController = TextEditingController();
  var seatsCountController = TextEditingController();
  var carDescriptionController = TextEditingController();
  var rentalPeriod = TextEditingController();
  var priceController = TextEditingController();
  var boardController = PageController();

  var formKey = GlobalKey<FormState>(); //key of the form used in the page


  bool val = true;
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => OfferCubit()..setLanguage(l: language)..readJson('offerPage'),
      child: BlocConsumer<OfferCubit, OfferStates>(
          listener: (context, state){},
          builder: (context, state){
            var offerCubit = OfferCubit.get(context);
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.black,),
                  ),
                  title:  Text(
                      "${offerCubit.items["offer"]??'offer'}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  centerTitle: true,

                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 20) ,
                      child: IconButton(
                        onPressed: () async {
                          if(formKey.currentState !. validate()){
                            print("start creating query");
                            print(await CachHelper.getData(key: "longitude"));
                            print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
                            Map<String, dynamic> query = {
                              "brand": offerCubit.finalBrand,
                              "model" : modelController.text,
                              "year": modelYearController.text,
                              "price": priceController.text,
                              "seatsCount": seatsCountController.text,
                              "transmission": offerCubit.transmission,
                              "fuelType": offerCubit.fuelType,
                              "bodyType": offerCubit.bodyType,
                              "hasAirConditioning": offerCubit.options[1],
                              "hasAbs":offerCubit.options[0],
                              "hasRadio": offerCubit.options[3],
                              "hasSunroof":offerCubit.options[2],
                              "period":rentalPeriod.text,
                              "description": carDescriptionController.text,
                              "longitude":await CachHelper.getData(key: "longitude") as double,
                              "latitude":await CachHelper.getData(key: "latitude") as double,
                              "images": offerCubit.imgs,
                            };
                            offerCubit.updeteUserInfo(query: query, context: context);
                          }
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                backgroundColor: Colors.white,

                body: Directionality(
                  textDirection: offerCubit.language == "English" ? TextDirection.ltr: TextDirection.rtl,
                  child: Form (
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 214,
                                width:500 ,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),

                                child: offerCubit.imgsFile.isNotEmpty? PageView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  controller: boardController,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Stack(
                                        children: [

                                          Image.file(
                                            offerCubit.imgsFile[index],
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),

                                          Center(
                                            child: Column(
                                              children: [
                                                const Expanded(child: Text("")),
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
                                                  count: offerCubit.imgsFile.length>5?5:offerCubit.imgsFile.length,
                                                ),
                                                const SizedBox(height: 6,)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: offerCubit.imgsFile.length>5?5:offerCubit.imgsFile.length,
                                )
                                    :Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed:() async {
                                        OfferCubit.get(context).pickImage();
                                      },
                                      icon: const Icon(Icons.add_a_photo),
                                      iconSize: 50,
                                      color: Colors.grey,
                                      tooltip:  "${offerCubit.items["addPhoto"]??''}",
                                    ),

                                    Text(
                                      "${offerCubit.items["upload"]??'offer'}",
                                      style: TextStyle(
                                          color: Colors.grey[700]
                                      ),
                                    )

                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Container(
                                alignment: offerCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                child:  Text(
                                  "${offerCubit.items["brand"]??'offer'}",
                                  style:const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4,),
                              Column(
                                children: [

                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["lada"]??""}",
                                          ),
                                          value: offerCubit.brands['lada'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'lada');
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title:  Text(
                                            "${offerCubit.items["verna"]??'verna'}",
                                          ),
                                          value: offerCubit.brands['verna'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'verna');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["daewoo"]??''}",
                                          ),
                                          value: offerCubit.brands['daewoo'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'daewoo');
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["nissan"]??''}",
                                          ),
                                          value: offerCubit.brands['nissan'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'nissan');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["elantra"]??''}",
                                          ),
                                          value: offerCubit.brands['elantra'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'elantra');
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["kia"]??''}",
                                          ),
                                          value: offerCubit.brands['kia'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'kia');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title:  Text(
                                            "${offerCubit.items["fiat"]??''}",
                                          ),
                                          value: offerCubit.brands['fiat'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'fiat');
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["bmw"]??''}",
                                          ),
                                          value: offerCubit.brands['bmw'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'bmw');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["mercedes"]??''}",
                                          ),
                                          value: offerCubit.brands['mercedes'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'mercedes');
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title:  Text(
                                            "${offerCubit.items["other"]??''}",
                                          ),
                                          value: offerCubit.brands['other'],
                                          onChanged: (value) {
                                            offerCubit.changeBrand(brand: 'other');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // more brands
                              Container(
                                alignment: offerCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                child: Text(
                                  "${offerCubit.items["body_type"]??''}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["convertible"]??''}",
                                          ),
                                          value: offerCubit.bodyTypes['Convertible'],
                                          onChanged: (value) {
                                            offerCubit.changeBodyType(body_type: 'Convertible');
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["coupe"]??''}",
                                          ),
                                          value: offerCubit.bodyTypes['Coupe'],
                                          onChanged: (value) {
                                            offerCubit.changeBodyType(body_type: 'Coupe');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["hatchback"]??''}",
                                          ),
                                          value: offerCubit.bodyTypes['Hatchback'],
                                          onChanged: (value) {
                                            offerCubit.changeBodyType(body_type: 'Hatchback');
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["mpv"]??''}",
                                          ),
                                          value: offerCubit.bodyTypes['MPV'],
                                          onChanged: (value) {
                                            offerCubit.changeBodyType(body_type: 'MPV');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["suv"]??''}",
                                          ),
                                          value: offerCubit.bodyTypes['SUV'],
                                          onChanged: (value) {
                                            offerCubit.changeBodyType(body_type: 'SUV');
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                            "${offerCubit.items["sedan"]??''}",
                                          ),
                                          value: offerCubit.bodyTypes['Sedan'],
                                          onChanged: (value) {
                                            offerCubit.changeBodyType(body_type: 'Sedan');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              TextFormField(
                                controller: modelController,
                                decoration:  InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: "${offerCubit.items["model"]??''}",
                                    hintText:   "${offerCubit.items["modelHint"]??''}",
                                    floatingLabelBehavior: FloatingLabelBehavior.always
                                ),

                                validator: (String? value){
                                  if(value == "" || value == null){
                                    return "${offerCubit.items["model_error"]??''}";
                                  }
                                },

                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              TextFormField(
                                controller: modelYearController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "${offerCubit.items["model_year"]??''}",
                                  hintText:  "${offerCubit.items["yearHint"]??''}",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),

                                validator: (String? value){
                                  if(value == "" || value == null){
                                    return "${offerCubit.items["model_year_error"]??''}";
                                  }
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              TextFormField(
                                controller: seatsCountController,
                                decoration:  InputDecoration(
                                  border:const OutlineInputBorder(),
                                  labelText: "${offerCubit.items["seat_count"]??''}",
                                  hintText:  "${offerCubit.items["seatHint"]??''}",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                                validator: (String? value){
                                  if(value == "" || value == null){
                                    return "${offerCubit.items["seat_count_error"]??''}";
                                  }
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              TextFormField(
                                controller: carDescriptionController,
                                decoration:  InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: "${offerCubit.items["description"]??''}",
                                    hintText: "${offerCubit.items["descriptionHint"]??''}",
                                    floatingLabelBehavior: FloatingLabelBehavior.always
                                ),

                                validator: (String? value){
                                  if(value == "" || value == null){
                                    return "${offerCubit.items["descriptionError"]??''}";
                                  }
                                },

                              ),

                              const SizedBox(
                                height : 10,
                              ),

                              Container(
                                alignment: offerCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                child: Text(
                                  "${offerCubit.items["transmission"]??''}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:[

                                  Expanded(
                                    child:ListTile(
                                      title:  Text("${offerCubit.items["automatic"]??''}",),
                                      leading: Radio(
                                        value: "automatic",
                                        groupValue: OfferCubit.get(context).transmission,
                                        onChanged: (value) {
                                          OfferCubit.get(context).toggleTransmissionButton(value);
                                        },
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: ListTile(
                                      title: Text("${offerCubit.items["manual"]??''}",),
                                      leading: Radio(
                                        value: "manual",
                                        groupValue: OfferCubit.get(context).transmission,
                                        onChanged: (value) {
                                          OfferCubit.get(context).toggleTransmissionButton(value);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height:10,
                              ),

                              Container(
                                alignment: offerCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                child:  Text(
                                  "${offerCubit.items["fuel_type"]??''}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:[
                                  Expanded(
                                    child:ListTile(
                                      title:  Text("${offerCubit.items["gas"]??''}",),
                                      leading: Radio(
                                        value: "gasoline",
                                        toggleable: true,
                                        groupValue: OfferCubit.get(context).fuelType,
                                        onChanged: (value) {
                                          OfferCubit.get(context).toggleGasButton(value);
                                        },
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: ListTile(
                                      title: Text("${offerCubit.items["natural_gas"]??''}",),
                                      leading: Radio(
                                        value: "natural gas",
                                        toggleable: true,
                                        groupValue: OfferCubit.get(context).fuelType,
                                        onChanged: (value) {
                                          OfferCubit.get(context).toggleGasButton(value);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                alignment: offerCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                child:  Text(
                                  "${offerCubit.items["options"]??''}",
                                  style:const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Expanded(
                                    child: Container(
                                      child: CheckboxListTile(
                                          contentPadding: EdgeInsets.all(0.0),
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title:  Text("${offerCubit.items["abs"]??''}",),
                                          autofocus: false,
                                          activeColor: Colors.blue,
                                          checkColor: Colors.white,
                                          selected: OfferCubit.get(context).options[0],
                                          value: OfferCubit.get(context).options[0],
                                          onChanged: (bool? value){
                                            OfferCubit.get(context).toggleOption(0);
                                          }
                                      ),
                                    ),
                                  ),


                                  Expanded(
                                      child: Container(
                                        child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: Text("${offerCubit.items["air_conditioning"]??''}",),
                                            autofocus: false,
                                            activeColor: Colors.blue,
                                            checkColor: Colors.white,
                                            selected: OfferCubit.get(context).options[1],
                                            value: OfferCubit.get(context).options[1],
                                            onChanged: (bool? value){
                                              OfferCubit.get(context).toggleOption(1);
                                            }
                                        ),
                                      )
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Expanded(
                                    child: Container(
                                      child: CheckboxListTile(
                                          contentPadding: EdgeInsets.all(0.0),
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title:  Text("${offerCubit.items["sunroof"]??''}",),
                                          autofocus: false,
                                          activeColor: Colors.blue,
                                          checkColor: Colors.white,
                                          selected: OfferCubit.get(context).options[2],
                                          value: OfferCubit.get(context).options[2],
                                          onChanged: (bool? value){
                                            OfferCubit.get(context).toggleOption(2);
                                          }
                                      ),
                                    ),
                                  ),


                                  Expanded(
                                      child: Container(
                                        child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title:  Text("${offerCubit.items["radio"]??''}",),
                                            autofocus: false,
                                            activeColor: Colors.blue,
                                            checkColor: Colors.white,
                                            selected: OfferCubit.get(context).options[3],
                                            value: OfferCubit.get(context).options[3],
                                            onChanged: (bool? value){
                                              OfferCubit.get(context).toggleOption(3);
                                            }
                                        ),
                                      )
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Container(
                                alignment: offerCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                child:  Text(
                                  "${offerCubit.items["location"]??''}",
                                  style:const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Container(
                                color: Colors.blue,
                                child: TextButton(
                                    style:const ButtonStyle(
                                    ),
                                    onPressed: (){
                                      navigateTo(context: context, screen: MapScreen());
                                    },
                                    child: Text(
                                        "${offerCubit.items["locationButton"]??''}",
                                        style:const TextStyle(
                                          color: Colors.white,
                                          // backgroundColor: Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )

                                    )
                                ),
                              ),

                              const SizedBox(
                                height:10,
                              ),

                              TextFormField(
                                controller: rentalPeriod,
                                decoration:  InputDecoration(
                                    border:const OutlineInputBorder(),
                                    labelText: "${offerCubit.items["rental_period"]??''}",
                                    hintText:"${offerCubit.items["rentalHint"]??''}",
                                    floatingLabelBehavior: FloatingLabelBehavior.always
                                ),
                                validator: (String? value){
                                  if(value == null || value == ""){
                                    return "${offerCubit.items["rental_period_error"]??''}";
                                  }
                                },
                              ),

                              const SizedBox(
                                height:10,
                              ),

                              TextFormField(
                                controller: priceController,
                                decoration:  InputDecoration(
                                    border:const OutlineInputBorder(),
                                    labelText: "${offerCubit.items["price"]??''}",
                                    hintText: "${offerCubit.items["priceHint"]??''}",
                                    floatingLabelBehavior: FloatingLabelBehavior.always
                                ),
                                validator: (String? value){
                                  if(value == null || value == ""){
                                    return "${offerCubit.items["priceError"]??''}";
                                  }
                                },
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            );
          }),

    );
  }

  List<String> images64(List<XFile> imgs){
    List<String> images = <String>[];
    for(var i = 0; i < imgs.length; i++){
      final bytes = File(imgs[i].path).readAsBytesSync();
      images.add(base64Encode(bytes));
    }
    return images;
  }

}


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tawsila',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CarOfferScreen(language: "Arabic"),
      debugShowCheckedModeBanner: false,
    );
  }

}
