import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/search-result/cubit/SearchStates.dart';
import 'package:tawsila/shared/end-points.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';

import '../../../shared/network/local/Cachhelper.dart';

class SearchCubit extends Cubit<SearchStates> {

  SearchCubit(): super(InitialSearchStates());

  static SearchCubit get(context) => BlocProvider.of(context);

  late List<Map<String, dynamic>> cars;
  int totalCount = 0;
  double latitude = 0.0;
  double longitude = 0.0;


  void getLocation() async {
    latitude = await CachHelper.getData(key: "latitude") as double;
    longitude = await CachHelper.getData(key: "longitude") as double;
  }
  void getData({
  required Map<String, dynamic> query
  }) {
    DioHelper.getData(url: SEARCHRESULTS, query: query)
        .then((value) {
          print("data: ${value.data['cars']}");
          cars = value.data['cars'];
          totalCount = value.data['totalCount'];
         });
  }
}