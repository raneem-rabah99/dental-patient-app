import 'dart:io';

import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/localization/app_strings.dart';
import 'package:dentaltreatment/features/home/presentation/managers/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadPanoramaSection extends StatefulWidget {
  /// 🔹 Callback to send selected image to parent (AiPage)
  final Function(File image) onImageSelected;

  const UploadPanoramaSection({super.key, required this.onImageSelected});

  @override
  State<UploadPanoramaSection> createState() => _UploadPanoramaSectionState();
}

class _UploadPanoramaSectionState extends State<UploadPanoramaSection> {
  XFile? _file;

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      setState(() {
        _file = pickedFile;
      });

      /// ✅ SEND IMAGE TO AIPAGE
      widget.onImageSelected(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageCubit>().isArabic;
    final strings = AppStrings(isArabic);

    return Column(
      children: [
        const SizedBox(height: 3),
        Container(
          width: 360,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  188,
                  188,
                  188,
                ).withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _pickFile,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_file == null) ...[
                  Iconupload.dental,
                  const SizedBox(height: 8),
                  Text(
                    strings.uploadPanorama,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    strings.chooseFile,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ] else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_file!.path),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _file!.name,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
