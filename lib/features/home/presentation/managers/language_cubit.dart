import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super("en");

  bool get isArabic => state == "ar";

  void toggleLang() {
    emit(isArabic ? "en" : "ar");
  }
}
