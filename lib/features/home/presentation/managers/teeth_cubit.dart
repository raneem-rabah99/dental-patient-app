import 'package:dentaltreatment/features/home/data/sources/teeth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'teeth_state.dart';

class TeethCubit extends Cubit<TeethState> {
  final TeethService service;

  TeethCubit(this.service) : super(TeethState.initial());

  Future<void> loadTeeth() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await service.getTeeth();

      emit(
        state.copyWith(
          isLoading: false,
          teeth: result, // قد تكون فارغة → هذا طبيعي
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
