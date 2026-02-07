import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Header extends StatelessWidget {
  Header({super.key});

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // ===== HEADER BACKGROUND =====
        Container(
          color: colors.surface,
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<Map<String, String?>>(
                future: _getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.darkblue,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text('Error', style: textTheme.bodyMedium);
                  }

                  final userData = snapshot.data;
                  final username = userData?['username'] ?? 'User';
                  final imagePath = userData?['image'];

                  const String defaultImage = 'assets/images/dentist.png';

                  ImageProvider imageProvider;

                  // CASE 1: Network image
                  if (imagePath != null &&
                      (imagePath.startsWith('http://') ||
                          imagePath.startsWith('https://'))) {
                    imageProvider = NetworkImage(imagePath);
                  }
                  // CASE 2: Local file
                  else if (imagePath != null &&
                      !kIsWeb &&
                      File(imagePath).existsSync()) {
                    imageProvider = FileImage(File(imagePath));
                  }
                  // CASE 3: Default asset
                  else {
                    imageProvider = const AssetImage(defaultImage);
                  }

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColor.gray,
                        backgroundImage: imageProvider,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        username,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),

              // ==========
            ],
          ),
        ),
      ],
    );
  }

  Future<Map<String, String?>> _getUserData() async {
    final username = await _secureStorage.read(key: 'username');
    final imagePath = await _secureStorage.read(key: 'image');
    return {'username': username, 'image': imagePath};
  }
}
