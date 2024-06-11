import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerr {
  Future<File> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickerImage = await picker.pickImage(
      source:
          inputSource == 'cammera' ? ImageSource.camera : ImageSource.gallery,
    );
    File imageFile = File(pickerImage!.path);
    return imageFile;
  }
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image select');
}
