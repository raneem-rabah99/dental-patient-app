import 'package:dentaltreatment/core/theme/app_assets.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/data/models/booking_card_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingCancelItem extends StatelessWidget {
  final BookingCardModel bookingCancel;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  BookingCancelItem({Key? key, required this.bookingCancel}) : super(key: key);

  Future<String?> _getUserImage() async {
    return await _secureStorage.read(key: 'image');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserImage(),
      builder: (context, snapshot) {
        String? imagePath = snapshot.data;
        String defaultImagePath = AppAssets.user;

        ImageProvider? imageProvider;
        if (imagePath != null && File(imagePath).existsSync()) {
          if (kIsWeb) {
            imageProvider = NetworkImage(imagePath);
          } else {
            imageProvider = FileImage(File(imagePath));
          }
        } else {
          imageProvider = AssetImage(defaultImagePath);
        }

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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: imageProvider,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookingCancel.userName,
                              style: const TextStyle(
                                fontFamily: 'Serif',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bookingCancel.location,
                              style: const TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 10),
                        const SizedBox(width: 5),
                        Text(
                          "From: ${bookingCancel.date}",
                          style: TextStyle(
                            fontFamily: 'Serif',
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.access_time, size: 10),
                        const SizedBox(width: 5),
                        Text(
                          "At: ${bookingCancel.time}",
                          style: TextStyle(
                            fontFamily: 'Serif',
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 25),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reason of Cancellation",
                          style: TextStyle(
                            fontFamily: 'Serif',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
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
      },
    );
  }
}
