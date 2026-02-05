import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_assets.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/data/models/booking_card_model.dart';
import 'package:dentaltreatment/features/home/presentation/managers/booking%20_card_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingwaittingItem extends StatefulWidget {
  final BookingCardModel bookingWaitting;

  const BookingwaittingItem({Key? key, required this.bookingWaitting})
    : super(key: key);

  @override
  _BookingwaittingItemState createState() => _BookingwaittingItemState();
}

class _BookingwaittingItemState extends State<BookingwaittingItem> {
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
      width: 800,
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
            padding: const EdgeInsets.only(left: 22, right: 10, bottom: 8),
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
                          widget.bookingWaitting.userName,
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
                              widget.bookingWaitting.location,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            PopupMenuButton<String>(
                              onSelected: (String result) {
                                if (result == 'edit') {
                                  print("Edit clicked");
                                } else if (result == 'delete') {
                                  print("Delete clicked");
                                  context
                                      .read<BookingCardCubit>()
                                      .deleteBooking(widget.bookingWaitting);
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Iconedit.edit,
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Iconedelete.delete,

                                      title: Text('Delete'),
                                    ),
                                  ),
                                ];
                              },
                              icon: const Icon(
                                Icons.more_horiz,
                                size: 24,
                                color: Color(0xffD2D2D2),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Iconecelender.celender,
                    const SizedBox(width: 5),
                    Text(
                      "From: ${widget.bookingWaitting.date}",
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
                      "At: ${widget.bookingWaitting.time}",
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
