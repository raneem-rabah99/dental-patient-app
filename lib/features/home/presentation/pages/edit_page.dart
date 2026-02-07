import 'dart:io';
import 'package:dentaltreatment/core/classes/icons_classes.dart';

import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/features/home/presentation/managers/delete_photo_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/delete_photo_state.dart';
import 'package:dentaltreatment/features/home/presentation/managers/update_photo_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/update_photo_state.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
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
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();

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
    final strings = AppStrings(context.watch<LanguageCubit>().isArabic);
    final isArabic = context.watch<LanguageCubit>().isArabic;
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<UpdatePhotoCubit, UpdatePhotoState>(
          listener: (context, state) {
            if (state.isLoading) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(strings.uploadingPhoto)));
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
        BlocListener<DeletePhotoCubit, DeletePhotoState>(
          listener: (context, state) async {
            if (state.isLoading) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(strings.deletingPhoto)));
            } else if (state.successMessage != null) {
              setState(() {
                _image = null;
                networkImageUrl = null;
              });
              await _secureStorage.delete(key: 'image');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
            child: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              elevation: 0,

              // ❌ نمنع Flutter من التحكم بالـ leading
              automaticallyImplyLeading: false,

              // ✅ نثبت الأيقونة في اليسار دائمًا
              actions: [
                Directionality(
                  textDirection: TextDirection.ltr, // يمنع الانعكاس
                  child: IconButton(
                    icon:
                        isArabic
                            ? Iconarowright.arrow(context) // → عربي
                            : Iconarrowleft.arrow(context), // ← إنجليزي
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
              title: Text(
                strings.editProfile,
                style: theme.appBarTheme.titleTextStyle,
              ),
              centerTitle: true,
            ),
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildProfileSection(context, strings)),
                Text(strings.displayName, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 5),
                buildTextFieldEdit(
                  usernameController,
                  strings.userName,
                  Icons.person,
                ),
                const SizedBox(height: 10),
                Text(strings.email, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 5),
                buildTextFieldEdit(
                  emailController,
                  strings.emailOptional,
                  Icons.email,
                ),
                const SizedBox(height: 10),
                Text(strings.phoneNumber, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 5),
                buildTextFieldEdit(
                  phoneController,
                  strings.phoneNumber,
                  Icons.phone,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: buildButtonProfilewithonpressed(
                    strings.saveEdit,
                    () => _saveChanges(context, strings),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= PROFILE =================
  Widget _buildProfileSection(BuildContext context, AppStrings strings) {
    final theme = Theme.of(context);

    ImageProvider imageProvider;
    if (_image != null) {
      imageProvider =
          kIsWeb ? NetworkImage(_image!.path) : FileImage(File(_image!.path));
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
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              radius: 50,
              backgroundImage: imageProvider,
            ),
            InkWell(
              onTap: _pickImage,
              child: Image.asset(
                'assets/icons/camera-01.png',
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(strings.selectPhoto, style: theme.textTheme.bodySmall),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => context.read<DeletePhotoCubit>().deletePhoto(),
            ),
            const Icon(Icons.horizontal_rule),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                if (_image != null) {
                  await context.read<UpdatePhotoCubit>().updatePhoto(
                    File(_image!.path),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(strings.selectImageFirst)),
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
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
        _isNewImage = true;
      });
    }
  }

  Future<void> _saveChanges(BuildContext context, AppStrings strings) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _secureStorage.write(key: 'username', value: usernameController.text);
    await _secureStorage.write(key: 'email', value: emailController.text);
    await _secureStorage.write(key: 'phone', value: phoneController.text);

    if (_isNewImage && _image != null) {
      await context.read<UpdatePhotoCubit>().updatePhoto(File(_image!.path));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.profileUpdated)));
    }
  }
}
