import 'package:dentaltreatment/features/home/data/models/booking_card_model.dart';
import 'package:dentaltreatment/features/home/presentation/managers/booking%20_card_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/booking_onprogress%20_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingOnProgressSection extends StatelessWidget {
  const BookingOnProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingCardCubit()..fetchBookings(),
      child: BlocBuilder<BookingCardCubit, List<BookingCardModel>>(
        builder: (context, bookings) {
          if (bookings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(left: 15.0),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: BookingOnProgressItem(
                      bookingOnProgress: bookings[index],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
