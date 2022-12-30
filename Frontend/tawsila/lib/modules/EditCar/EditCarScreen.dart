import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tawsila/modules/mange-offer/ManageOfferScreen.dart';
import 'package:tawsila/shared/bloc_observer.dart';
import 'package:tawsila/shared/components/Components.dart';
import '../../../shared/network/local/Cachhelper.dart';
import '../home-page/Map.dart';
import 'EditCarCubit/EditCarCubit.dart';
import 'EditCarCubit/EditCarStates.dart';

class EditCarScreen extends StatelessWidget{

  final String language;      //hold the language of the program(arabic-english)
  final id;
  EditCarScreen({super.key, required this.language, required this.id});

  String brand = "";
  String model = "";
  String modelYear = "";
  String seatsCount = "";
  String carDescription ="";
  String rentalPeriod = "";
  String price = "";
  bool isChanged = false;

  var boardController = PageController();

  var formKey = GlobalKey<FormState>(); //key of the form used in the page

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => EditCarCubit()..setLanguage(l: language)..readJson('editPage')..getCarById(id),
      child: BlocConsumer<EditCarCubit, EditCarStates>(
          listener: (context, state){},
          builder: (context, state){
            var editCubit = EditCarCubit.get(context);
            return Directionality(
              textDirection: editCubit.language == "English" ? TextDirection.ltr: TextDirection.rtl,
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.black,),
                    ),
                    title:  Text(
                        "${editCubit.items["offer"]??'offer'}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    centerTitle: true,
                  ),
                  backgroundColor: Colors.white,

                  body: Directionality(
                    textDirection: editCubit.language == "English" ? TextDirection.ltr: TextDirection.rtl,
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

                                  child: editCubit.imgsFile.isNotEmpty? PageView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    controller: boardController,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Stack(
                                          children: [

                                            Image(
                                              image: NetworkImage(editCubit.carResponse['images'][index]),
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
                                                    count: editCubit.imgsFile.length>5?5:editCubit.imgsFile.length,
                                                  ),
                                                  const SizedBox(height: 6,)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: editCubit.imgsFile.length>5?5:editCubit.imgsFile.length,
                                  )
                                      :const Text(
                                          "no images for this car",
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                //brands
                                Container(
                                  alignment: editCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                  child:  Text(
                                    "${editCubit.items["brand"]??'offer'}",
                                    style:const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 4,),

                                //brands options
                                Column(
                                  children: [

                                    Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: Text(
                                              "${editCubit.items["lada"]??""}",
                                            ),
                                            value: editCubit.brands['lada'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'lada');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title:  Text(
                                              "${editCubit.items["verna"]??'verna'}",
                                            ),
                                            value: editCubit.brands['verna'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'verna');
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
                                              "${editCubit.items["daewoo"]??''}",
                                            ),
                                            value: editCubit.brands['daewoo'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'daewoo');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: Text(
                                              "${editCubit.items["nissan"]??''}",
                                            ),
                                            value: editCubit.brands['nissan'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'nissan');
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
                                              "${editCubit.items["elantra"]??''}",
                                            ),
                                            value: editCubit.brands['elantra'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'elantra');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: Text(
                                              "${editCubit.items["kia"]??''}",
                                            ),
                                            value: editCubit.brands['kia'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'kia');
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
                                              "${editCubit.items["fiat"]??''}",
                                            ),
                                            value: editCubit.brands['fiat'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'fiat');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: Text(
                                              "${editCubit.items["bmw"]??''}",
                                            ),
                                            value: editCubit.brands['bmw'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'bmw');
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
                                              "${editCubit.items["mercedes"]??''}",
                                            ),
                                            value: editCubit.brands['mercedes'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'mercedes');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title:  Text(
                                              "${editCubit.items["other"]??''}",
                                            ),
                                            value: editCubit.brands['other'],
                                            onChanged: (value) {
                                              editCubit.changeBrand(brand: 'other');
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                //body Type
                                Container(
                                  alignment: editCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                  child: Text(
                                    "${editCubit.items["body_type"]??''}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 4,),

                                //body types options
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: Text(
                                              "${editCubit.items["convertible"]??''}",
                                            ),
                                            value: editCubit.bodyTypes['Convertible'],
                                            onChanged: (value) {
                                              editCubit.changeBodyType(body_type: 'Convertible');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: Text(
                                              "${editCubit.items["coupe"]??''}",
                                            ),
                                            value: editCubit.bodyTypes['Coupe'],
                                            onChanged: (value) {
                                              editCubit.changeBodyType(body_type: 'Coupe');
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
                                              "${editCubit.items["hatchback"]??''}",
                                            ),
                                            value: editCubit.bodyTypes['Hatchback'],
                                            onChanged: (value) {
                                              editCubit.changeBodyType(body_type: 'Hatchback');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: Text(
                                              "${editCubit.items["mpv"]??''}",
                                            ),
                                            value: editCubit.bodyTypes['MPV'],
                                            onChanged: (value) {
                                              editCubit.changeBodyType(body_type: 'MPV');
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
                                              "${editCubit.items["suv"]??''}",
                                            ),
                                            value: editCubit.bodyTypes['SUV'],
                                            onChanged: (value) {
                                              editCubit.changeBodyType(body_type: 'SUV');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: Text(
                                              "${editCubit.items["sedan"]??''}",
                                            ),
                                            value: editCubit.bodyTypes['Sedan'],
                                            onChanged: (value) {
                                              editCubit.changeBodyType(body_type: 'Sedan');
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

                                //model field
                                TextFormField(
                                  initialValue: "${editCubit.carResponse["model"]}",
                                  decoration:  InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: "${editCubit.items["model"]??''}",
                                      hintText:   "${editCubit.items["modelHint"]??''}",
                                      floatingLabelBehavior: FloatingLabelBehavior.always
                                  ),

                                  onChanged: (value){
                                    if(value != editCubit.carResponse["model"]){isChanged |= true;}
                                    else {isChanged |= false;}
                                  },

                                  validator: (String? value){
                                    if(value == "" || value == null){
                                      return "${editCubit.items["model_error"]??''}";
                                    }
                                  },

                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                //model year field
                                TextFormField(
                                  initialValue:"${editCubit.carResponse["year"]}",
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: "${editCubit.items["model_year"]??''}",
                                    hintText:  "${editCubit.items["yearHint"]??''}",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),

                                  onChanged: (value){
                                    if(value != editCubit.carResponse["year"]){isChanged |= true;}
                                    else {isChanged |= false;}
                                  },

                                  validator: (String? value){
                                    if(value == "" || value == null){
                                      return "${editCubit.items["model_year_error"]??''}";
                                    }
                                  },
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                //seatCount field
                                TextFormField(
                                  initialValue:"${editCubit.carResponse["seatsCount"]}",
                                  keyboardType: TextInputType.number,
                                  decoration:  InputDecoration(
                                    border:const OutlineInputBorder(),
                                    labelText: "${editCubit.items["seat_count"]??''}",
                                    hintText:  "${editCubit.items["seatHint"]??''}",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),

                                  onChanged: (value){
                                    if(value != editCubit.carResponse["seatsCount"]){isChanged |= true;}
                                    else {isChanged |= false;}
                                  },
                                  validator: (String? value){
                                    if(value == "" || value == null){
                                      return "${editCubit.items["seat_count_error"]??''}";
                                    }
                                  },
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                //car description field
                                TextFormField(
                                  initialValue: "${editCubit.carResponse["description"]}",
                                  decoration:  InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: "${editCubit.items["description"]??''}",
                                      hintText: "${editCubit.items["descriptionHint"]??''}",
                                      floatingLabelBehavior: FloatingLabelBehavior.always
                                  ),

                                  onChanged: (value){
                                    if(value != editCubit.carResponse["description"]){isChanged |= true;}
                                    else {isChanged |= false;}
                                  },

                                  validator: (String? value){
                                    if(value == "" || value == null){
                                      return "${editCubit.items["descriptionError"]??''}";
                                    }
                                  },

                                ),

                                const SizedBox(
                                  height : 10,
                                ),

                                //transmission
                                Container(
                                  alignment: editCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                  child: Text(
                                    "${editCubit.items["transmission"]??''}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),

                                //transmission options
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[

                                    Expanded(
                                      child:ListTile(
                                        title:  Text("${editCubit.items["automatic"]??''}",),
                                        leading: Radio(
                                          value: "automatic",
                                          groupValue: editCubit.transmission,
                                          onChanged: (value) {
                                            editCubit.toggleTransmissionButton(value);
                                          },
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: ListTile(
                                        title: Text("${editCubit.items["manual"]??''}",),
                                        leading: Radio(
                                          value: "manual",
                                          groupValue: editCubit.transmission,
                                          onChanged: (value) {
                                            editCubit.toggleTransmissionButton(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height:10,
                                ),

                                //fuel type
                                Container(
                                  alignment: editCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                  child:  Text(
                                    "${editCubit.items["fuel_type"]??''}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),

                                //fuel type options
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Expanded(
                                      child:ListTile(
                                        title:  Text("${editCubit.items["gas"]??''}",),
                                        leading: Radio(
                                          value: "gasoline",
                                          toggleable: true,
                                          groupValue: editCubit.fuelType,
                                          onChanged: (value) {
                                            editCubit.toggleGasButton(value);
                                          },
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: ListTile(
                                        title: Text("${editCubit.items["natural_gas"]??''}",),
                                        leading: Radio(
                                          value: "natural gas",
                                          toggleable: true,
                                          groupValue: editCubit.fuelType,
                                          onChanged: (value) {
                                            editCubit.toggleGasButton(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                //car options
                                Container(
                                  alignment: editCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                  child:  Text(
                                    "${editCubit.items["options"]??''}",
                                    style:const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),

                                //car options different options
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Expanded(
                                      child: Container(
                                        child: CheckboxListTile(
                                            contentPadding: EdgeInsets.all(0.0),
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title:  Text("${editCubit.items["abs"]??''}",),
                                            autofocus: false,
                                            activeColor: Colors.blue,
                                            checkColor: Colors.white,
                                            selected: editCubit.options[0],
                                            value: editCubit.options[0],
                                            onChanged: (bool? value){
                                              editCubit.toggleOption(0);
                                            }
                                        ),
                                      ),
                                    ),


                                    Expanded(
                                        child: Container(
                                          child: CheckboxListTile(
                                              controlAffinity: ListTileControlAffinity.leading,
                                              title: Text("${editCubit.items["air_conditioning"]??''}",),
                                              autofocus: false,
                                              activeColor: Colors.blue,
                                              checkColor: Colors.white,
                                              selected: editCubit.options[1],
                                              value: editCubit.options[1],
                                              onChanged: (bool? value){
                                                editCubit.toggleOption(1);
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
                                            title:  Text("${editCubit.items["sunroof"]??''}",),
                                            autofocus: false,
                                            activeColor: Colors.blue,
                                            checkColor: Colors.white,
                                            selected: editCubit.options[2],
                                            value: editCubit.options[2],
                                            onChanged: (bool? value){
                                              editCubit.toggleOption(2);
                                            }
                                        ),
                                      ),
                                    ),


                                    Expanded(
                                        child: Container(
                                          child: CheckboxListTile(
                                              controlAffinity: ListTileControlAffinity.leading,
                                              title:  Text("${editCubit.items["radio"]??''}",),
                                              autofocus: false,
                                              activeColor: Colors.blue,
                                              checkColor: Colors.white,
                                              selected: editCubit.options[3],
                                              value: editCubit.options[3],
                                              onChanged: (bool? value){
                                                editCubit.toggleOption(3);
                                              }
                                          ),
                                        )
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                //location
                                Container(
                                  alignment: editCubit.language == "English" ? Alignment.topLeft : Alignment.topRight,
                                  child:  Text(
                                    "${editCubit.items["location"]??''}",
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

                                //map button
                                Container(
                                  color: Colors.blue,
                                  child: TextButton(
                                      style:const ButtonStyle(
                                      ),
                                      onPressed: (){
                                        navigateTo(context: context, screen: MapScreen());
                                      },
                                      child: Text(
                                          "${editCubit.items["locationButton"]??''}",
                                          style:const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          )
                                      )
                                  ),
                                ),

                                const SizedBox(
                                  height:10,
                                ),

                                //rental period field
                                TextFormField(
                                  initialValue: "${editCubit.carResponse["period"]}",
                                  keyboardType: TextInputType.number,
                                  decoration:  InputDecoration(
                                      border:const OutlineInputBorder(),
                                      labelText: "${editCubit.items["rental_period"]??''}",
                                      hintText:"${editCubit.items["rentalHint"]??''}",
                                      floatingLabelBehavior: FloatingLabelBehavior.always
                                  ),
                                  onChanged: (value){
                                    if(value != editCubit.carResponse["period"]){isChanged |= true;}
                                    else {isChanged |= false;}
                                  },
                                  validator: (String? value){
                                    if(value == null || value == ""){
                                      return "${editCubit.items["rental_period_error"]??''}";
                                    }
                                  },
                                ),

                                const SizedBox(
                                  height:10,
                                ),

                                //price field
                                TextFormField(
                                  initialValue: "${editCubit.carResponse["price"]}",
                                  keyboardType: TextInputType.number,
                                  decoration:  InputDecoration(
                                      border:const OutlineInputBorder(),
                                      labelText: "${editCubit.items["price"]??''}",
                                      hintText: "${editCubit.items["priceHint"]??''}",
                                      floatingLabelBehavior: FloatingLabelBehavior.always
                                  ),
                                  onChanged: (value){
                                    if(value != editCubit.carResponse["price"]){isChanged |= true;}
                                    else {isChanged |= false;}
                                  },

                                  validator: (String? value){
                                    if(value == null || value == ""){
                                      return "${editCubit.items["priceError"]??''}";
                                    }
                                  },
                                ),


                                const SizedBox(
                                  height: 50,
                                ),


                                Row(
                                  children: [

                                    //update car button
                                    TextButton(
                                      onPressed: () async{
                                        if(formKey.currentState !. validate()){
                                          if(isChanged){
                                            print("start updating query");
                                            print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
                                            Map<String, dynamic> query = {
                                              "brand": editCubit.finalBrand,
                                              "model" : model,
                                              "year": modelYear,
                                              "price": price,
                                              "seatsCount": seatsCount,
                                              "transmission": editCubit.transmission,
                                              "fuelType": editCubit.fuelType,
                                              "bodyType": editCubit.bodyType,
                                              "hasAirConditioning": editCubit.options[1],
                                              "hasAbs":editCubit.options[0],
                                              "hasRadio": editCubit.options[3],
                                              "hasSunroof":editCubit.options[2],
                                              "period":rentalPeriod,
                                              "description": carDescription,
                                              "longitude":await CachHelper.getData(key: "longitude") as double,
                                              "latitude":await CachHelper.getData(key: "latitude") as double,
                                              "images": editCubit.imgs,
                                            };



                                            editCubit.updateCar(id: editCubit.carResponse["id"], query: query);
                                        }
                                        }
                                        navigateTo(context: context, screen: ManageOfferScreen(language: language));
                                      },
                                        child: Row(
                                           children: const [
                                             Text("confirm"),
                                             Icon(Icons.check),
                                          ],
                                        ),
                                    ),


                                    //delete button
                                    Container(
                                      color: Colors.red,
                                      child: TextButton(
                                        onPressed: (){
                                          editCubit.deleteCarById(editCubit.carResponse["id"]);
                                          navigateTo(context: context, screen: ManageOfferScreen(language: language));
                                        },
                                        child: Row(
                                          children: const [
                                            Text("Remove"),
                                            Icon(Icons.close,),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ),
            );
          }),

    );
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
      home: EditCarScreen(language: "English", id: 3),
      debugShowCheckedModeBanner: false,
    );
  }

}
