import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_assets.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/data/models/booking_card_model.dart';
import 'package:dentaltreatment/features/home/presentation/managers/booking%20_card_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingdoneItem extends StatefulWidget {
  final BookingCardModel bookingDone;

  const BookingdoneItem({Key? key, required this.bookingDone})
    : super(key: key);

  @override
  _BookingdoneItemState createState() => _BookingdoneItemState();
}

class _BookingdoneItemState extends State<BookingdoneItem> {
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
    print("Retrieved Today's Booking Image Path: $imagePath");
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
            padding: const EdgeInsets.only(
              left: 22,
              right: 10,
              bottom: 8,
              top: 10,
            ),
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
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookingDone.userName,
                          style: const TextStyle(
                            fontFamily: 'Serif',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            Iconlocation.location,
                            const SizedBox(width: 5),
                            Text(
                              widget.bookingDone.location,
                              style: const TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2.0,
                                decorationStyle: TextDecorationStyle.solid,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Iconecelender.celender,
                    const SizedBox(width: 5),
                    Text(
                      "From: ${widget.bookingDone.date}",
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Iconclock.clock,
                    const SizedBox(width: 5),
                    Text(
                      "At: ${widget.bookingDone.time}",
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Note From Doctor"),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Image.asset(AppAssets.doctor),
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
