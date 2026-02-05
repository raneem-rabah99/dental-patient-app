import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/booking_card_model.dart';
import '../../data/sources/booking_service.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingService service;

  BookingCubit(this.service) : super(BookingState.initial());

  Future<void> loadBookings() async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final list = await service.getBookings();
      emit(state.copyWith(loading: false, bookings: list));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  List<BookingCardModel> filter(String status) {
    return state.bookings
        .where((b) => b.status?.toLowerCase() == status.toLowerCase())
        .toList();
  }
}
