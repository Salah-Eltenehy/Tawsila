import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/EditCar/EditCarScreen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:tawsila/modules/home-page/HomePage.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'ManageOfferCubit/ManageOfferStates.dart';
import 'ManageOfferCubit/MangeOfferCubit.dart';


class ManageOfferScreen extends StatelessWidget {
  final String language;
  ManageOfferScreen({super.key, required this.language});
  Widget reload = const Center(child: CircularProgressIndicator());
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ManageOfferCubit()..getUserCars(),
      child: BlocConsumer<ManageOfferCubit, ManageOfferStates>(
          listener: (context, state) {},
          builder:(context, state) {
            var manageCubit = ManageOfferCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    navigateAndFinish(context: context, screen: HomePageScreen(language: language));
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black,),
                ),
                centerTitle: true,
                title: const Text(
                  "Manage Your Offer",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black
                  ),
                ),
              ),

              body: ConditionalBuilder(
                  condition: manageCubit.totalCount > 0,
                  builder: (BuildContext context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18, top: 8),
                          child: Text(
                            "${manageCubit.totalCount} results found",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return buildCar(manageCubit.cars[index],context,manageCubit);
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                height: 4,
                                width: double.infinity,
                              ),
                              itemCount: manageCubit.totalCount),
                        ),
                      ],
                    );
                  },
                  fallback: (context) => ConditionalBuilder(
                    condition: manageCubit.totalCount != 0,
                    builder: (BuildContext context) => reload,
                    fallback: (BuildContext context)=> const Center(child: Text("there`s no available offers")),
                  )//(context) => reload,
              ),
            );
          }
      ),
    );
  }


  Widget buildCar(Map<String, dynamic> car,var context,var m) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        height: 200,
        child: InkWell(
          onTap: () async {
            Map<String, dynamic> x = await m.getCarById('${car['id']}');
            navigateTo(context: context, screen: EditCarScreen(language: language, id: '${car['id']}', carResponse: x));
          },
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
                  image: NetworkImage('${car['thumbnail']}'),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Expanded(child: Text("")),
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
                              "${car['updatedAt'].toString().substring(0,16)}",
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
      ),
    );
  }
}