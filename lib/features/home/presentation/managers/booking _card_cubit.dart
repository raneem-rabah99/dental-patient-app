import 'package:dentaltreatment/features/home/data/models/booking_card_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCardCubit extends Cubit<List<BookingCardModel>> {
  BookingCardCubit() : super([]);

  void fetchBookings() {
    emit([
      BookingCardModel(
        id: 1,
        userName: "Alice Johnson",

        location: "Main Street 45",
        date: "30 - 7 - 2024",
        time: "08:30 AM",
      ),
      BookingCardModel(
        id: 2,
        userName: "John Doe",

        location: "Main Street 45",
        date: "31 - 7 - 2024",
        time: "10:00 AM",
      ),
    ]);
  }

  void deleteBooking(BookingCardModel booking) {
    emit(state.where((b) => b != booking).toList());
  }
}
