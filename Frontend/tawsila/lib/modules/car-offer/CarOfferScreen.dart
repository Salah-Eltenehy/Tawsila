import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/car-offer/Cubit/OfferCubit.dart';
import 'package:tawsila/shared/bloc_observer.dart';

import 'Cubit/OfferStates.dart';

class CarOfferScreen extends StatelessWidget{

  final String language;      //hold the language of the program(arabic-english)
  
  CarOfferScreen({super.key, required this.language});

  //Controllers for all text fields in the page
  var brandController = TextEditingController();
  var modelController = TextEditingController();
  var modelYearController = TextEditingController();
  var seatsCountController = TextEditingController();
  var bodyTypeController = TextEditingController();
  var rentalPeriod = TextEditingController();

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
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    centerTitle: true,

                    actions: [
                      Container(
                        margin: const EdgeInsets.only(right: 20) ,
                        child: IconButton(
                            onPressed: (){
                              if(formKey.currentState !. validate()){
                                print ("finish the offer");}
                              },
                            icon: const ImageIcon(
                              AssetImage("images/right.png"),
                              size: 24,
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
                                InkWell(
                                  onTap: () async {
                                    OfferCubit.get(context).pickImage();
                                    print(OfferCubit.get(context).images);
                                  },
                                  
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,

                                    child: SingleChildScrollView(
                                      child: Container(
                                        height: 150,
                                        width: 500,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 3,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ) ,

                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed:() async {
                                                OfferCubit.get(context).pickImage();
                                              },
                                              icon: const Icon(Icons.add_a_photo),
                                              iconSize: 50,
                                              color: Colors.grey,
                                              tooltip: "add photo",
                                            ),

                                            Text(
                                              "upload Photos For the Vehicle",
                                              style: TextStyle(
                                                  color: Colors.grey[700]
                                              ),
                                            )

                                          ],
                                        ),

                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  alignment: Alignment.topLeft,
                                  child: const Text(
                                    "Brands",
                                    style: TextStyle(
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
                                            title: const Text(
                                                "LADA"
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
                                            title: const Text(
                                                "Verna"
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
                                            title: const Text(
                                                "Daewoo"
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
                                            title: const Text(
                                                "Nissan"
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
                                            title: const Text(
                                                "Elantra"
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
                                            title: const Text(
                                                "KIA"
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
                                            title: const Text(
                                                "Fiat"
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
                                            title: const Text(
                                                "BMW"
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
                                            title: const Text(
                                                "Mercedes"
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
                                            title: const Text(
                                                "Other"
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
                                  alignment: Alignment.topLeft,
                                  child: const Text(
                                    "More Brands",
                                    style: TextStyle(
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
                                            title: const Text(
                                                "Convertible"
                                            ),
                                            value: offerCubit.moreBrands['Convertible'],
                                            onChanged: (value) {
                                               offerCubit.changeMoreBrand(brand: 'Convertible');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: const Text(
                                                "Coupe"
                                            ),
                                            value: offerCubit.moreBrands['Coupe'],
                                            onChanged: (value) {
                                              offerCubit.changeMoreBrand(brand: 'Coupe');
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
                                            title: const Text(
                                                "Hatchback"
                                            ),
                                            value: offerCubit.moreBrands['Hatchback'],
                                            onChanged: (value) {
                                                offerCubit.changeMoreBrand(brand: 'Hatchback');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: const Text(
                                                "MPV"
                                            ),
                                            value: offerCubit.moreBrands['MPV'],
                                            onChanged: (value) {
                                               offerCubit.changeMoreBrand(brand: 'MPV');
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
                                            title: const Text(
                                                "SUV"
                                            ),
                                            value: offerCubit.moreBrands['SUV'],
                                            onChanged: (value) {
                                                offerCubit.changeMoreBrand(brand: 'SUV');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            title: const Text(
                                                "Sedan"
                                            ),
                                            value: offerCubit.moreBrands['Sedan'],
                                            onChanged: (value) {
                                                offerCubit.changeMoreBrand(brand: 'Sedan');
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
                                      hintText: "Enter a model",
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
                                    hintText: "year of fabrication (e.g. 1998)",
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
                                    hintText: "number of seats",
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
                                  controller: bodyTypeController,
                                  decoration:  InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: "${offerCubit.items["body_type"]??''}",
                                      hintText: "Enter a type",
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  validator: (String? value){
                                    if(value == null || value == ""){
                                      return "${offerCubit.items["body_type_error"]??''}";
                                    }
                                  },
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  alignment: Alignment.topLeft,
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
                                  alignment: Alignment.topLeft,
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
                                  alignment: Alignment.topLeft,
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

                                TextFormField(
                                  controller: rentalPeriod,
                                  decoration:  InputDecoration(
                                    border:const OutlineInputBorder(),
                                    labelText: "${offerCubit.items["rental_period"]??''}",
                                    hintText: "e.g. 5 days",
                                    floatingLabelBehavior: FloatingLabelBehavior.always
                                  ),
                                  validator: (String? value){
                                    if(value == null || value == ""){
                                      return "${offerCubit.items["rental_period_error"]??''}";
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
      home: CarOfferScreen(language: "English"),
      debugShowCheckedModeBanner: false,
    );
  }
}
