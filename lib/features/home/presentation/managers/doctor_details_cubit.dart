import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_details_state.dart';
import '../../data/sources/doctor_details_service.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final Map<String, dynamic> doctor;
  final DoctorDetailsService _service = DoctorDetailsService();

  DoctorDetailsCubit(this.doctor) : super(DoctorDetailsState.initial());

  // ================= BACKEND TIME RANGE =================
  // Example: "09:00:00 - 17:00:00"
  late final String rawRange = (doctor["time"] ?? "00:00:00 - 23:59:59")
      .replaceAll(" ", "");

  // ================= RANGE START =================
  TimeOfDay get rangeStart {
    final start = rawRange.split("-").first;
    return _parseTime(start);
  }

  // ================= RANGE END =================
  TimeOfDay get rangeEnd {
    final end = rawRange.split("-").last;
    return _parseTime(end);
  }

  // ================= SAFE TIME PARSER =================
  TimeOfDay _parseTime(String time) {
    final parts = time.trim().split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  // ================= RANGE VALIDATION =================
  bool _isTimeWithinRange(TimeOfDay t) {
    final selected = t.hour * 60 + t.minute;
    final start = rangeStart.hour * 60 + rangeStart.minute;
    final end = rangeEnd.hour * 60 + rangeEnd.minute;

    // same-day range (09:00–17:00)
    if (start <= end) {
      return selected >= start && selected <= end;
    }

    // overnight range (22:00–04:00)
    return selected >= start || selected <= end;
  }

  // ================= SELECT DATE =================
  void selectDate(DateTime date) {
    emit(
      state.copyWith(
        selectedDate: date,

        // 🔥 GUARANTEE TIME
        selectedTime: state.selectedTime ?? rangeStart,

        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  // ================= SELECT TIME =================
  void selectTime(TimeOfDay time) {
    // 🔥 SAFETY: fallback to rangeStart
    final safeTime = _isTimeWithinRange(time) ? time : rangeStart;

    emit(
      state.copyWith(
        selectedTime: safeTime,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  // ================= FORMAT TIME (24H) =================
  String formatTime24(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  // ================= BOOK APPOINTMENT =================
  Future<void> bookAppointment() async {
    if (doctor["id"] == null) {
      emit(state.copyWith(errorMessage: "Invalid doctor ID"));
      return;
    }

    if (state.selectedDate == null) {
      emit(state.copyWith(errorMessage: "Please choose a date"));
      return;
    }

    // 🔥 FINAL GUARANTEE — NEVER NULL
    final TimeOfDay selectedTime = state.selectedTime ?? rangeStart;

    // Final validation
    if (!_isTimeWithinRange(selectedTime)) {
      emit(
        state.copyWith(
          errorMessage: "This time is not available. Allowed time: $rawRange",
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final date =
          "${state.selectedDate!.year}-${state.selectedDate!.month.toString().padLeft(2, '0')}-${state.selectedDate!.day.toString().padLeft(2, '0')}";

      final time = formatTime24(selectedTime);

      final result = await _service.bookAppointment(
        doctorId: doctor["id"],
        date: date,
        time: time,
      );

      emit(
        state.copyWith(
          isLoading: false,
          successMessage:
              result["message"] ?? "Appointment booked successfully",
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
