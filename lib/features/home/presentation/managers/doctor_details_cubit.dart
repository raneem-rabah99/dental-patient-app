import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_details_state.dart';
import '../../data/sources/doctor_details_service.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final Map<String, dynamic> doctor;
  final DoctorDetailsService _service = DoctorDetailsService();

  DoctorDetailsCubit(this.doctor) : super(DoctorDetailsState.initial());

  // ----------------------------- SELECT DATE -----------------------------
  void selectDate(DateTime date) {
    if (isClosed) return;
    emit(
      state.copyWith(
        selectedDate: date,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  // ----------------------------- SELECT TIME -----------------------------
  void selectTime(TimeOfDay time) {
    if (isClosed) return;
    emit(
      state.copyWith(
        selectedTime: time,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  // ----------------------------- FORMAT TIME -----------------------------
  String formatTime24(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  // ----------------------------- BOOK APPOINTMENT -----------------------------
  Future<void> bookAppointment() async {
    // -------- Validate Doctor ID --------
    if (doctor["id"] == null || doctor["id"] is! int) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: "Invalid doctor ID"));
      return;
    }

    // -------- Validate Date --------
    if (state.selectedDate == null) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: "Please choose a date"));
      return;
    }

    // -------- Validate Time --------
    if (state.selectedTime == null) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: "Please choose a time"));
      return;
    }

    if (isClosed) return;

    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );

    try {
      // Format date
      final date =
          "${state.selectedDate!.year}-${state.selectedDate!.month.toString().padLeft(2, '0')}-${state.selectedDate!.day.toString().padLeft(2, '0')}";

      // Format time
      final time = formatTime24(state.selectedTime!);

      // Call API
      final result = await _service.bookAppointment(
        doctorId: doctor["id"],
        date: date,
        time: time,
      );

      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          successMessage:
              result["message"] ?? "Appointment booked successfully",
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
