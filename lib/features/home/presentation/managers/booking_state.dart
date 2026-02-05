import 'package:dentaltreatment/features/home/data/models/booking_card_model.dart';

class BookingState {
  final bool loading;
  final List<BookingCardModel> bookings;
  final String? error;

  BookingState({required this.loading, required this.bookings, this.error});

  factory BookingState.initial() =>
      BookingState(loading: false, bookings: [], error: null);

  BookingState copyWith({
    bool? loading,
    List<BookingCardModel>? bookings,
    String? error,
  }) {
    return BookingState(
      loading: loading ?? this.loading,
      bookings: bookings ?? this.bookings,
      error: error,
    );
  }
}
