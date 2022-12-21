import 'package:flutter_bloc/flutter_bloc.dart';

import 'AppStates.dart';

class TawsilaMainProvider extends Cubit<TawsilaStates> {
  TawsilaMainProvider(): super(TawsliaInitialState());

  static TawsilaMainProvider get(context) => BlocProvider.of(context);
  bool isEnglish = true;
  String dropDownValue = "English";
  changeLanguage({
    required bool isEn
  }) {
    isEnglish = isEn;
    dropDownValue = isEn? "English" : "العربية";
    emit(ChangeTawsilaLanguage());
  }
}