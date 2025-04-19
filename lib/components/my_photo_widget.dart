import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MyPhotoWidget extends StatefulWidget {
  final Function _takePhoto;
  final Function _pickImagesFromGallery;
  final List<XFile> _selectedImages;

  const MyPhotoWidget({
    super.key,
    required Function takePhoto,
    required Function pickImagesFromGallery,
    required List<XFile> selectedImages,
  })  : _takePhoto = takePhoto,
        _pickImagesFromGallery = pickImagesFromGallery,
        _selectedImages = selectedImages;

  @override
  State<MyPhotoWidget> createState() => _MyPhotoWidgetState();
}

class _MyPhotoWidgetState extends State<MyPhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Select Option',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.blue[900],
                  fontFamily: "Mont",
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        await widget._takePhoto();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            Icon(Icons.camera_alt, color: Colors.blue[900]),
                            const SizedBox(width: 10),
                            const Text(
                              'Take a photo',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        widget._pickImagesFromGallery();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            Icon(Icons.photo_library, color: Colors.blue[900]),
                            const SizedBox(width: 10),
                            const Text(
                              'Choose from gallery',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 1.5),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: widget._selectedImages.isEmpty
            ? Column(
          children: [
            Icon(
              Icons.add_photo_alternate_rounded,
              size: 50,
              color: Colors.blue[900],
            ),
            const SizedBox(height: 8),
            Text(
              "Add Photos Of The Damaged Item",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
                fontFamily: "Mont",
              ),
            ),
          ],
        )
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget._selectedImages.asMap().entries.map(
                  (entry) {
                int index = entry.key;
                XFile image = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget._selectedImages.isNotEmpty &&
                            widget._selectedImages[index].path.isNotEmpty
                            ? (kIsWeb
                            ? Image.network(
                          widget._selectedImages[index].path,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : File(widget._selectedImages[index].path)
                            .existsSync()
                            ? Image.file(
                          File(widget._selectedImages[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                          child: const Icon(Icons.error),
                        ))
                            : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                          child: const Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget._selectedImages.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                              Colors.blue[900]?.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
