import 'dart:io';
import 'dart:ui';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  const ImageInput({
    required this.onSelectImage,
    super.key});

  final Function onSelectImage;

  

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final imageFiile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if(imageFiile == null){
      return;
    }
    setState(() {
      _storedImage = File(imageFiile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFiile.path);
    final savedImage = await File(imageFiile.path).copy('${appDir.path}/$fileName');  //use File(imageFile.path) instead of 'imageFile' only
    widget.onSelectImage(savedImage);

  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            icon: Icon(Icons.camera_outlined),
            label: Text('Take Picture'),
          ),
        ),
      ],
    );
  }
}
