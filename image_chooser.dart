import 'dart:io';
import 'package:image_picker/image_picker.dart';

enum imageSources { camera, gallery }

class ImageChooser {
  ImageChooser(this.source);
  final imageSources source;
  Future<File> pickImage() async {
    var tempStore;
    source == imageSources.gallery
        // ignore: deprecated_member_use
        ? tempStore = await ImagePicker.pickImage(source: ImageSource.gallery)
        // ignore: deprecated_member_use
        : tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    return tempStore;
  }
}
