import 'dart:io';
import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/data/sources/delete_photo_service.dart';
import 'package:dentaltreatment/features/home/data/sources/update_photo_service.dart';
import 'package:dentaltreatment/features/home/presentation/managers/delete_photo_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/delete_photo_state.dart';
import 'package:dentaltreatment/features/home/presentation/managers/update_photo_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/update_photo_state.dart';
import 'package:dentaltreatment/features/home/presentation/pages/home_page.dart';
import 'package:dentaltreatment/features/home/presentation/widgets/widgets_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  XFile? _image;
  bool _isNewImage = false;

  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? networkImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final username = await _secureStorage.read(key: 'username');
    final email = await _secureStorage.read(key: 'email');
    final phone = await _secureStorage.read(key: 'phone');
    final imagePath = await _secureStorage.read(key: 'image');

    setState(() {
      usernameController.text = username ?? '';
      emailController.text = email ?? '';
      phoneController.text = phone ?? '';

      if (imagePath != null && imagePath.isNotEmpty) {
        if (imagePath.startsWith("http")) {
          networkImageUrl = imagePath;
        } else {
          _image = XFile(imagePath);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// 🔵 UPDATE PHOTO LISTENER
        BlocListener<UpdatePhotoCubit, UpdatePhotoState>(
          listener: (context, state) {
            if (state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Uploading photo...")),
              );
            } else if (state.successMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
        ),

        /// 🔴 DELETE PHOTO LISTENER
        BlocListener<DeletePhotoCubit, DeletePhotoState>(
          listener: (context, state) async {
            if (state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleting photo...")),
              );
            } else if (state.successMessage != null) {
              setState(() {
                _image = null;
                networkImageUrl = null;
              });

              await _secureStorage.delete(key: 'image');

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
        ),
      ],

      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.colorapp,
          leading: IconButton(
            icon: Iconarrowleft.arowleft,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(
              fontFamily: 'Gabarito',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF234E9D),
            ),
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildProfileSection()),

                const Text(
                  "Display Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                buildTextFieldEdit(
                  usernameController,
                  "User Name",
                  Icons.person,
                ),

                const SizedBox(height: 10),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                buildTextFieldEdit(
                  emailController,
                  "Email (Optional)",
                  Icons.email,
                ),

                const SizedBox(height: 10),
                const Text(
                  "Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                buildTextFieldEdit(
                  phoneController,
                  "Phone Number",
                  Icons.phone,
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: buildButtonProfilewithonpressed(
                    'Save Edit',
                    () => _saveChanges(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    ImageProvider imageProvider;

    if (_image != null) {
      imageProvider =
          kIsWeb
              ? NetworkImage(_image!.path)
              : FileImage(File(_image!.path)) as ImageProvider;
    } else if (networkImageUrl != null) {
      imageProvider = NetworkImage(networkImageUrl!);
    } else {
      imageProvider = const AssetImage('assets/images/default_profile.png');
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 199, 228, 255),
              radius: 50,
              backgroundImage: imageProvider,
            ),

            /// ONLY CAMERA ICON IS CLICKABLE
            Positioned(
              child: InkWell(
                onTap: () async {
                  await _pickImage();
                },
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    'assets/icons/camera-01.png',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        const Text(
          "select your photo",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 28),
              onPressed: () {
                context.read<DeletePhotoCubit>().deletePhoto();
              },
            ),

            const SizedBox(width: 10),
            const Icon(Icons.horizontal_rule, size: 28),

            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 28),
              onPressed: () async {
                if (_image != null) {
                  await context.read<UpdatePhotoCubit>().updatePhoto(
                    File(_image!.path),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Select image first!")),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
        _isNewImage = true;
      });
    }
  }

  Future<void> _saveChanges(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _secureStorage.write(key: 'username', value: usernameController.text);
    await _secureStorage.write(key: 'email', value: emailController.text);
    await _secureStorage.write(key: 'phone', value: phoneController.text);

    if (_isNewImage && _image != null) {
      await context.read<UpdatePhotoCubit>().updatePhoto(File(_image!.path));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    }
  }
}
