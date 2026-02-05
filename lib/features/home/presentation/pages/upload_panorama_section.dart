import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPanoramaSection extends StatefulWidget {
  const UploadPanoramaSection({super.key});

  @override
  State<UploadPanoramaSection> createState() => _UploadPanoramaSectionState();
}

class _UploadPanoramaSectionState extends State<UploadPanoramaSection> {
  XFile? _file;

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _file = pickedFile;
      });
      print('Picked file: ${pickedFile.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 3),
        Container(
          width: 360,
          height: 300,
          decoration: BoxDecoration(
            /*image: const DecorationImage(
              image: AssetImage('assets/images/transparent_bg.png'),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),*/
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
                    'Upload Panorama',
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose File',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ] else ...[
                  // Show preview or file name after upload
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
