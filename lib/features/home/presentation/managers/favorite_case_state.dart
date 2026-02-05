import 'package:dentaltreatment/features/home/data/models/favorite_case_model.dart';

class FavoriteCaseState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final List<FavoriteCaseModel> cases;

  const FavoriteCaseState({
    required this.isLoading,
    required this.cases,
    this.errorMessage,
    this.successMessage,
  });

  factory FavoriteCaseState.initial() {
    return const FavoriteCaseState(
      isLoading: false,
      cases: [],
      errorMessage: null,
      successMessage: null,
    );
  }

  FavoriteCaseState copyWith({
    bool? isLoading,
    List<FavoriteCaseModel>? cases,
    String? errorMessage,
    String? successMessage,
  }) {
    return FavoriteCaseState(
      isLoading: isLoading ?? this.isLoading,
      cases: cases ?? this.cases,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
