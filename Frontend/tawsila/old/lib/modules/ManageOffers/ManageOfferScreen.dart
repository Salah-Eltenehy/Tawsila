import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/ManageOffers/Cubit/ManageOfferCubit.dart';
import 'package:tawsila/modules/search-result/cubit/SeachCubit.dart';
import 'package:tawsila/modules/search-result/cubit/SearchStates.dart';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:tawsila/shared/components/Components.dart';

import '../filter/FilterScreen.dart';
import 'Cubit/ManageOfferStates.dart';

class ManageOfferScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ManageOfferCubit(),
      child: BlocConsumer<ManageOfferCubit, ManageOfferStates>(
          listener: (context, state) {},
          builder:(context, state) {
            var manageOfferCubit = ManageOfferCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black,),
                ),
                centerTitle: true,
                title: const Text(
                  "Manage Your Offers",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black
                  ),
                ),
              ),

              body: ConditionalBuilder(
                  condition: manageOfferCubit.total > 0,
                  builder: (BuildContext context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18, top: 8),
                          child: Text(
                            "${manageOfferCubit.total} results found",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return buildCar(manageOfferCubit.car);
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                height: 4,
                                width: double.infinity,
                              ),
                              itemCount: manageOfferCubit.total),
                        ),
                      ],
                    );
                  },
                  fallback: (context) => const Center(child: CircularProgressIndicator())
              ),
            );
          }
      ),
    );
  }


  Widget buildCar(Map<String, dynamic> car) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        height: 200,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 3),
                gradient: const LinearGradient(
                    colors: [Colors.black, Colors.black54],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center
                ),
              ),
              child: Image(
                image: AssetImage("${car['image']}"),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                const Expanded(child: Text("")),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${car['brand']}  ${car['model']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                      Row(
                        children:  [
                          const Icon(Icons.ac_unit, color: Colors.white,),
                          Text(
                            "${car['year']}.  ${car['seatsCount']} Seats",
                            style: const TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${car['price']} EGP",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children:  [
                          Text(
                            "${car['date']}",
                            style: const TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            "per day",
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
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
      home: ManageOfferScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
