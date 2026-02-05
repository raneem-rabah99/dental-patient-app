import 'package:dentaltreatment/features/auth/data/sources/customer_info_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/customer_info_model.dart';
import 'customer_info_state.dart';

class CustomerInfoCubit extends Cubit<CustomerInfoState> {
  final CustomerInfoService _service;

  CustomerInfoCubit(this._service) : super(CustomerInfoState.initial());

  Future<void> uploadCustomerInfo(CustomerInfoModel model) async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );
    try {
      final response = await _service.uploadInfo(model);

      if (response['status'] == true) {
        emit(
          state.copyWith(isLoading: false, successMessage: response['message']),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: response['message'] ?? 'Failed to update info',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
