import 'package:dentaltreatment/features/home/data/sources/favorite_case_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dentaltreatment/features/home/data/models/favorite_case_model.dart';
import 'package:dentaltreatment/features/home/presentation/managers/favorite_case_state.dart';

class FavoriteCaseCubit extends Cubit<FavoriteCaseState> {
  final FavoriteCaseService service;

  FavoriteCaseCubit(this.service) : super(FavoriteCaseState.initial());

  Future<void> loadFavoriteCases() async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await service.getFavoriteCases();
      if (isClosed) return; // ✅ بعد await

      if (result.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            cases: [
              FavoriteCaseModel(
                firstName: "Alice",
                lastName: "Johnson",
                averageRate: 4.5,
              ),
              FavoriteCaseModel(
                firstName: "John",
                lastName: "Doe",
                averageRate: 4.5,
              ),
            ],
            errorMessage:
                "Failed to load data from API. Showing default items.",
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            cases: result,
            successMessage: "Favorite cases loaded successfully",
          ),
        );
      }
    } catch (e) {
      if (isClosed) return; // ✅ مهم جدًا
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
