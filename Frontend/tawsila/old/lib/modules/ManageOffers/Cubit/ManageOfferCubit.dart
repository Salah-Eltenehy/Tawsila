import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ManageOfferStates.dart';

class ManageOfferCubit extends Cubit<ManageOfferStates>{

  ManageOfferCubit(): super(ManageOfferInitialState());

  static ManageOfferCubit get(context) => BlocProvider.of(context);

  Map<String, dynamic> car = {
    "image": "assets/images/nissan.jpg",
    "brand": "Nissan",
    "model": "Sanny",
    "seatsCount": 4,
    "year": "2022",
    "price": 250,
    "date": "25 Nov 2022"
  };

  int total = ManageOfferCubit().car.keys.length;
}

