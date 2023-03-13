// This class is used to hold methods that are repeatedly used from the file picker.
// The goal is to simpilfiy the API of the file picker.
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerWM {
  // pick a single file
  static Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      // User canceled the picker
      return null;
    }
  }
}
