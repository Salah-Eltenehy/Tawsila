

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/search-result/cubit/SeachCubit.dart';
import 'package:tawsila/modules/search-result/cubit/SearchStates.dart';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class SearchResultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit()..getData(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder:(context, state) {
          var searchCubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: ConditionalBuilder(
              condition: searchCubit.cars.isNotEmpty,
              builder: (BuildContext context) {
                return Column(
                  children: [
                    Text(
                      '${searchCubit.totalCount} results found',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: Colors.white
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListView.separated(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: buildCar(searchCubit.cars[index]),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 4,
                          width: double.infinity,
                        ),
                        itemCount: searchCubit.cars.length),
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
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: [Colors.black]
            ),
          ),
          child: Image(
            width: double.infinity,
            height: double.infinity,
            image: NetworkImage(car['image']),
          ),
        ),
        Column(
          children:  [
            const Expanded(child: Text("")),
            Row(
              children: [
                Text(
                    "${car['brand']}  ${car['model']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children:  [
                    const Icon(Icons.ac_unit, color: Colors.white,),
                    Text(
                      "${car['year']}.${car['seatsCount']} Seats",
                      style: const TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${car['price']} EGP",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children:  [
                    Text(
                      "${car['year']}.${car['seatsCount']} Seats",
                      style: const TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "per day",
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
