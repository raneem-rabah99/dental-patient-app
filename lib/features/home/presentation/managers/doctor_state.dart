import 'package:dentaltreatment/features/home/data/models/doctor_model.dart';

class DoctorState {
  final bool isLoading;
  final String? error;
  final List<DoctorModel> doctors;

  DoctorState({required this.isLoading, required this.doctors, this.error});

  factory DoctorState.initial() =>
      DoctorState(isLoading: false, doctors: [], error: null);

  DoctorState copyWith({
    bool? isLoading,
    List<DoctorModel>? doctors,
    String? error,
  }) {
    return DoctorState(
      isLoading: isLoading ?? this.isLoading,
      doctors: doctors ?? this.doctors,
      error: error,
    );
  }
}
