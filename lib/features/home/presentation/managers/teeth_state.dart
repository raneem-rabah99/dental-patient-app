import 'package:dentaltreatment/features/home/data/models/tooth_detection.dart';

class TeethState {
  final bool isLoading;
  final String? error;
  final List<ToothDetection> teeth;

  TeethState({required this.isLoading, required this.teeth, this.error});

  factory TeethState.initial() =>
      TeethState(isLoading: false, teeth: [], error: null);

  TeethState copyWith({
    bool? isLoading,
    List<ToothDetection>? teeth,
    String? error,
  }) {
    return TeethState(
      isLoading: isLoading ?? this.isLoading,
      teeth: teeth ?? this.teeth,
      error: error,
    );
  }
}
