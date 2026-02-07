import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_status_state.dart';
import '../../data/sources/booking_status_service.dart';
import '../../data/sources/booking_delete_service.dart';

class BookingStatusCubit extends Cubit<BookingStatusState> {
  final BookingStatusService service;
  final BookingDeleteService deleteService = BookingDeleteService();

  BookingStatusCubit(this.service) : super(BookingStatusState.initial());

  Future<void> loadStatus(String status) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final bookings = await service.loadByStatus(status);
      if (isClosed) return; // ✅
      emit(state.copyWith(isLoading: false, bookings: bookings));
    } catch (e) {
      if (isClosed) return; // ✅ ناقصة
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteBooking(int id) async {
    try {
      final message = await deleteService.deleteBooking(id);
      if (isClosed) return; // ✅

      final updatedList = state.bookings.where((b) => b.id != id).toList();

      emit(
        state.copyWith(
          bookings: updatedList,
          successMessage: message,
          error: null,
        ),
      );
    } catch (e) {
      if (isClosed) return; // ✅ ناقصة
      emit(state.copyWith(error: e.toString()));
    }
  }
}
