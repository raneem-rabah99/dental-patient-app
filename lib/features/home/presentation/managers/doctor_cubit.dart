import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dentaltreatment/features/home/data/models/doctor_model.dart';
import 'package:dentaltreatment/features/home/data/sources/doctor_service.dart';
import 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit(this.service) : super(DoctorState.initial());

  final DoctorService service;

  List<DoctorModel> _allDoctors = [];
  Timer? _debounce;

  Future<void> loadDoctors() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final list = await service.fetchDoctors();
      _allDoctors = list;
      emit(state.copyWith(isLoading: false, doctors: list, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  String cleanAddress(String raw) {
    if (raw.contains("|")) {
      return raw.split("|").last.trim();
    }
    return raw.trim();
  }

  // 🔥 Search with debounce (Google-like)
  void searchDoctors(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.trim().isEmpty) {
        emit(state.copyWith(doctors: _allDoctors));
        return;
      }

      final q = query.toLowerCase();

      final filtered =
          _allDoctors.where((d) {
            final loc = cleanAddress(d.location).toLowerCase();
            return d.name.toLowerCase().contains(q) ||
                d.specialization.toLowerCase().contains(q) ||
                loc.contains(q);
          }).toList();

      emit(state.copyWith(doctors: filtered));
    });
  }
}
