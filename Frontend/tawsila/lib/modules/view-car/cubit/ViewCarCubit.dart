import 'ViewCarStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCarCubit extends Cubit<ViewCarStates> {
  ViewCarCubit(): super(InitialViewCarStates());

  static ViewCarCubit get(context) => BlocProvider.of(context);

  Map<String, dynamic> car = {
    "images": [
        "assets/images/2.png",
        "assets/images/2.png",
        "assets/images/2.png",
        "assets/images/2.png",
    ],
    "ownerImage": "assets/images/owner.png",
    "ownerName": "Salah Ahmed",
    "price": "500",
    "location": "Alexandria",
    "maxDays": 3,
    "fuelType": "Natural Gas",
    "seatsCount": 4,
    "air": true,
    "radio": true,
    "gear": "Manual",
    "description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    "reviews": [
      "Very good car",
      "bla bla bla",
      "Nice car"
    ]
  };

}