import 'package:dentaltreatment/core/theme/app_assets.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/data/models/booking_card_model.dart';
import 'package:dentaltreatment/features/home/presentation/managers/booking%20_card_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingOnProgressItem extends StatefulWidget {
  final BookingCardModel bookingOnProgress;

  const BookingOnProgressItem({Key? key, required this.bookingOnProgress})
    : super(key: key);

  @override
  _BookingOnProgressItemState createState() => _BookingOnProgressItemState();
}

class _BookingOnProgressItemState extends State<BookingOnProgressItem> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserImage();
  }

  Future<void> _loadUserImage() async {
    String? storedImagePath = await _secureStorage.read(key: 'image');
    setState(() {
      imagePath = storedImagePath;
    });
    print("Retrieved Booking Image Path: $imagePath");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                color: AppColor.darkblue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          imagePath != null && File(imagePath!).existsSync()
                              ? FileImage(File(imagePath!))
                              : AssetImage(AppAssets.user) as ImageProvider,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookingOnProgress.userName,
                          style: const TextStyle(
                            fontFamily: 'Serif',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 13),
                            const SizedBox(width: 5),
                            Text(
                              widget.bookingOnProgress.location,
                              style: const TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 13),
                    const SizedBox(width: 5),
                    Text("From: ${widget.bookingOnProgress.date}"),
                    const SizedBox(width: 10),
                    Icon(Icons.access_time, size: 13),
                    const SizedBox(width: 5),
                    Text("At: ${widget.bookingOnProgress.time}"),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Color(0xffE3E3E3)),
                        ),
                      ),
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          fontFamily: 'Serif',
                          color: Color(0xff666666),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        context.read<BookingCardCubit>().deleteBooking(
                          widget.bookingOnProgress,
                        );
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Color(0xffE3E3E3)),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'Serif',
                          color: Color(0xff666666),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
