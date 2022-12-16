import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/search-result/cubit/SearchStates.dart';
import 'package:tawsila/shared/end-points.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';

class SearchCubit extends Cubit<SearchStates> {

  SearchCubit(): super(InitialSearchStates());

  static SearchCubit get(context) => BlocProvider.of(context);

  List<Map<String, dynamic>>? cars;
  int totalCount = 0;
  void getData() {
    DioHelper.getData(url: SEARCHRESULTS)
        .then((value) {
          print("data: ${value}");
          cars = value.data['cars'];
          totalCount = value.data['totalCount'];
         });
  }
}