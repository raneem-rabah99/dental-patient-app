import 'package:dentaltreatment/features/home/presentation/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Header extends StatelessWidget {
  Header({super.key});
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top gray background
        Container(
          color: const Color.fromARGB(255, 237, 234, 234),
          padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<Map<String, String?>>(
                future: _getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final userData = snapshot.data;
                  final username = userData?['username'] ?? 'User';
                  final imagePath = userData?['image'];

                  // Default local asset image
                  const String defaultImage = 'assets/images/dentist.png';

                  ImageProvider imageProvider;

                  // ✔ CASE 1: Backend URL image
                  if (imagePath != null &&
                      (imagePath.startsWith("http://") ||
                          imagePath.startsWith("https://"))) {
                    imageProvider = NetworkImage(imagePath);
                  }
                  // ✔ CASE 2: Local file
                  else if (imagePath != null && File(imagePath).existsSync()) {
                    imageProvider =
                        kIsWeb
                            ? NetworkImage(imagePath)
                            : FileImage(File(imagePath));
                  }
                  // ✔ CASE 3: Default image
                  else {
                    imageProvider = const AssetImage(defaultImage);
                  }

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        backgroundImage: imageProvider, // << SHOW IMAGE
                      ),

                      const SizedBox(width: 10),

                      Text(
                        username,
                        style: const TextStyle(
                          fontFamily: 'Serif',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),

              // Notifications Icon
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Map<String, String?>> _getUserData() async {
    String? username = await _secureStorage.read(key: 'username');
    String? imagePath = await _secureStorage.read(key: 'image');
    return {'username': username, 'image': imagePath};
  }
}
