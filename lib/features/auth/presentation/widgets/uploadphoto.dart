import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadDocumentWidget extends StatefulWidget {
  final String title;
  final String placeholderText;
  final double height;
  final double width;
  final Function(XFile?)? onFilePicked;
  final IconData? icon; // ← New optional icon

  const UploadDocumentWidget({
    super.key,
    required this.title,
    required this.placeholderText,
    this.height = 100,
    this.width = double.infinity,
    this.onFilePicked,
    this.icon, // ← Accept icon from outside
  });

  @override
  State<UploadDocumentWidget> createState() => _UploadDocumentWidgetState();
}

class _UploadDocumentWidgetState extends State<UploadDocumentWidget> {
  XFile? _file;

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _file = pickedFile;
      });

      if (widget.onFilePicked != null) {
        widget.onFilePicked!(pickedFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Serif',
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickFile,
          child: DottedBorder(
            child: Container(
              width: widget.width,
              height: widget.height,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null && _file == null) ...[
                    Icon(widget.icon, color: Color(0xffA3A3A3)),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      _file == null ? widget.placeholderText : _file!.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xffA3A3A3),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
