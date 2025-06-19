import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:liteline/utils/helpers.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    // Request permissions
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus galleryStatus = await Permission.photos.request();

    if (cameraStatus.isGranted || galleryStatus.isGranted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        setState(() {
          _imageFile = pickedFile;
        });
        if (pickedFile != null) {
          showToast(context, 'Image picked successfully!');
        }
      } catch (e) {
        showToast(context, 'Error picking image: $e', backgroundColor: Colors.red);
      }
    } else {
      showToast(context, 'Permission denied to access camera or gallery.', backgroundColor: Colors.red);
      showCustomAlert(
        context,
        title: 'Permission Required',
        message: 'Please grant camera and/or gallery permissions from app settings to use this feature.',
        confirmText: 'Open Settings',
        cancelText: 'Cancel',
        onConfirm: () {
          openAppSettings(); 
        },
        icon: Icons.info_outline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera & Gallery'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? const Text(
                    'No image selected.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  )
                : Image.file(
                    File(_imageFile!.path),
                    height: 300,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick from Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}