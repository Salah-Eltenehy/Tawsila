import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:tawsila/modules/car-offer/Cubit/OfferCubit.dart';
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
  var ImageController = MultiImagePickerController(
    maxImages: 5,
  );
  var formKey = GlobalKey<FormState>(); //key of the form used in the page


bool val = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          create: (BuildContext context) => OfferCubit(), 

          child: BlocConsumer<OfferCubit, OfferStates>(
            listener: (context, state){},
            builder: (context, state){
              var offerCubit = OfferCubit.get(context);
              return Scaffold(
                  appBar: AppBar(
                    title:  Text(
                        "${offerCubit.items["offer"]??''}",
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
                              color: Colors.white,

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

                                const SizedBox(
                                  height: 10,
                                ),

                                TextFormField(
                                  controller: brandController,
                                  decoration: InputDecoration(
                                    border:const OutlineInputBorder(),
                                    labelText: "${offerCubit.items["brand"]??''}",
                                    hintText: "Enter a brand",
                                  ),
                                  validator: (String? value){
                                    if(value == "" || value == null){
                                      return("${offerCubit.items["brand_error"]??''}");
                                    }
                                  }
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Expanded(
                                          child: Container(
                                            child: CheckboxListTile(
                                              contentPadding: EdgeInsets.all(0.0),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Expanded(
                                      child: Container(
                                        child: CheckboxListTile(
                                            contentPadding: EdgeInsets.all(0.0),
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
                                    labelText: "${offerCubit.items["rent"]??''}",
                                    hintText: "e.g. 5 days",
                                  ),
                                  validator: (String? value){
                                    if(value == null || value == ""){
                                      return "${offerCubit.items["rent_error"]??''}";
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