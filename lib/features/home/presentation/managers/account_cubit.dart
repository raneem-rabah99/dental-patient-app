import 'package:flutter_bloc/flutter_bloc.dart';

class AccountCubit extends Cubit<bool> {
  AccountCubit() : super(false);

  void logout() {
    emit(true);
  }

  void deleteAccount() {
    emit(true);
  }
}
