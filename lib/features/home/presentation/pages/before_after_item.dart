import 'dart:io';
import 'package:dentaltreatment/core/theme/app_assets.dart';
import 'package:dentaltreatment/features/home/data/models/favorite_case_model.dart';
import 'package:dentaltreatment/features/home/presentation/pages/doctor_card.dart';
import 'package:dentaltreatment/features/home/presentation/pages/doctor_details_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BeforeAfterItem extends StatelessWidget {
  final FavoriteCaseModel caseItem;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  BeforeAfterItem({Key? key, required this.caseItem}) : super(key: key);

  Future<String?> _getUserImage() async {
    return await _secureStorage.read(key: 'image');
  }

  /// FIX URL BUILDER
  String buildImageUrl(String? image) {
    if (image == null || image.isEmpty) return "";

    if (image.startsWith("http")) return image;

    if (image.contains("storage")) {
      return "https://6d332e482271.ngrok-free.app/api/$image";
    }

    return "https://6d332e482271.ngrok-free.app/api/storage/$image";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserImage(),
      builder: (context, snapshot) {
        String? imagePath = snapshot.data;
        String defaultImagePath = AppAssets.user;

        ImageProvider imageProvider;
        if (imagePath != null && File(imagePath).existsSync()) {
          imageProvider =
              kIsWeb
                  ? NetworkImage(imagePath)
                  : FileImage(File(imagePath)) as ImageProvider;
        } else {
          imageProvider = AssetImage(defaultImagePath);
        }

        return Container(
          margin: const EdgeInsets.only(left: 2, right: 8),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 35),
                child: DoctorResultCard(
                  beforeImage: buildImageUrl(caseItem.photoBefore),
                  afterImage: buildImageUrl(caseItem.photoAfter),
                  doctorName:
                      "${caseItem.firstName ?? ''} ${caseItem.lastName ?? ''}",
                  rating: caseItem.averageRate ?? 0.0,

                  // ***************************************
                  //          NEW NAVIGATION LOGIC
                  // ***************************************
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DoctorDetailsPage(
                              doctor: {
                                "name":
                                    "${caseItem.firstName ?? ''} ${caseItem.lastName ?? ''}",
                                "image": buildImageUrl(caseItem.photoBefore),
                                "location": caseItem.location ?? "Unknown",
                                "specialization":
                                    caseItem.specialization ?? "Dental",
                                "distance": caseItem.distance ?? "2 km",
                                "time": caseItem.availableTime ?? "9 AM - 5 PM",
                              },
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
