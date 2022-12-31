import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/shared/components/Components.dart';
import 'package:tawsila/shared/network/remote/DioHelper.dart';
import '../../../shared/end-points.dart';
import '../../../shared/network/local/Cachhelper.dart';
import 'ManageOfferStates.dart';

class ManageOfferCubit extends Cubit<ManageOfferStates> {

  ManageOfferCubit(): super(InitialManageOfferState());

  static ManageOfferCubit get(context) => BlocProvider.of(context);

  late List cars;
  int totalCount = -1;
  double latitude = 0.0;
  double longitude = 0.0;


  Map<String, dynamic> carResponse = {};
  Future<Map<String, dynamic>> getCarById(id)  async {
    print("i am in the function");
    String token = await CachHelper.getData(key: 'token') as String;
    print("the toke is ${token}");
    await DioHelper.getData(
        url: 'cars/${id}',
        token: token,
        query: {}
    ).then((value) async {
      print(value.data);
      carResponse = value.data;
      //updateInfo(carResponse);
      emit(state);
    });
    return carResponse;
  }

  void getUserCars() async {
    print("i am heeeeerrrrrreeeee");
    String token = await CachHelper.getData(key: 'token') as String;
    Map<String, dynamic> t = parseJwt(token);
    String id = t[USERID];

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