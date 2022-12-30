import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';
import '../../../shared/network/local/Cachhelper.dart';
import 'ManageOfferStates.dart';

class ManageOfferCubit extends Cubit<ManageOfferStates> {

  ManageOfferCubit(): super(InitialManageOfferState());

  static ManageOfferCubit get(context) => BlocProvider.of(context);

  late List cars;
  int totalCount = -1;
  double latitude = 0.0;
  double longitude = 0.0;


  void getUserCars() async {
    print("i am heeeeerrrrrreeeee");
    String token = await CachHelper.getData(key: 'token');
    Map<String, dynamic> t = parseJwt(token);
    String id = t["id"];

    await DioHelper.getData(
        url:"users/${id}/cars",
        query: {},
        token: token
    ).then((value) {
      cars = value.data['cars'];
      print("data: ${cars}");
      totalCount = cars.length;
      print(totalCount);
      emit(state);
    });
  }
}