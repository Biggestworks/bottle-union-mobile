import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:photo_view/photo_view.dart';

class PictureProvider {
  final picker = ImagePicker();

  Future<File?> openCamera(BuildContext context) async {
    XFile? _cameraPicture = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 600,
      maxWidth: 600,
    );
    if (_cameraPicture != null) {
      return File(_cameraPicture.path);
    } else {
      return null;
    }
  }

  Future<File?> openGallery(BuildContext context) async {
    XFile? _galleryPicture = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 600,
      maxWidth: 600,
    );
    if (_galleryPicture != null) {
      return File(_galleryPicture.path);
    } else {
      return null;
    }
  }

  Future<File> showChoiceDialog(BuildContext context) async {
    File? image;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose one"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () async {
                    await openCamera(context).then((img) {
                      image = img!;
                      Get.back();
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () async {
                    await openGallery(context).then((img) {
                      image = img!;
                      Get.back();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    return image!;
  }

  // showPreviewImage(BuildContext context, File image) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Stack(
  //           children: [
  //             PhotoView(
  //               imageProvider: FileImage(image),
  //               backgroundDecoration: BoxDecoration(
  //                 color: Colors.transparent
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 10, left: 2),
  //               child: GestureDetector(
  //                 onTap: () {
  //                   Get.back();
  //                 },
  //                 child: Icon(Icons.clear, color: Colors.white, size: 40,),
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //   );
  // }

  // Future saveImageToGallery(File img) async {
  //   await GallerySaver.saveImage(img.path).then((value) => print('image saved'));
  // }
}
