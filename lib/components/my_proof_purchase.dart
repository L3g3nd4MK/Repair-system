import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProofOfPurchaseWidget extends StatefulWidget {
  final Function _takePhoto;
  final Function _pickProofImage;
  final XFile? proofImage;
  final String? warrantyOption;
  final Function? onRemove;

  const ProofOfPurchaseWidget({
    super.key,
    required Function takePhoto,
    required Function pickProofImage,
    required this.proofImage,
    required this.warrantyOption, this.onRemove,
  })  : _takePhoto = takePhoto,
        _pickProofImage = pickProofImage;

  @override
  State<ProofOfPurchaseWidget> createState() => _ProofOfPurchaseWidgetState();
}

class _ProofOfPurchaseWidgetState extends State<ProofOfPurchaseWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // If item under warranty -> obtain proof of purchase
        if (widget.warrantyOption == 'Yes, it is under warranty')
          GestureDetector(
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
                              padding:
                              const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt,
                                      color: Colors.blue[900]),
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
                              widget._pickProofImage();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  Icon(Icons.photo_library,
                                      color: Colors.blue[900]),
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
              child: widget.proofImage == null
                  ? Column(
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.blue[900],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Upload Proof of Purchase",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              )

                  : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(widget.proofImage!.path,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover)
                        : Image.file(File(widget.proofImage!.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        widget.onRemove?.call();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[900]?.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // If item not under warranty
        if (widget.warrantyOption == 'No, it is not')
          Text(
            "Note: After submitting a repair request, you will receive an estimated cost."
                " Once you have the estimate, you can schedule a pickup for your luggage."
                " You can view the estimated repair cost on your Bookings page.",
            style: TextStyle(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
              fontFamily: "Mont",
            ),
          ),
      ],
    );
  }
}
