import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/components/my_photo_widget.dart';
import 'package:final_app/components/my_proof_purchase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../components/input_decoration.dart';

class CustomerRepairPage extends StatefulWidget {
  const CustomerRepairPage({super.key});

  @override
  State<CustomerRepairPage> createState() => _CustomerRepairPageState();
}

class _CustomerRepairPageState extends State<CustomerRepairPage> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  XFile? proofImage;
  String? warrantyOption;
  String? selectedLuggageType;
  final user = FirebaseAuth.instance.currentUser!;
  String customerFullName = "";
  String customerEmail = "";
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
    fetchCustomerData();
  }

  Future<void> fetchCustomerData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          customerFullName = userDoc['fullName'] ?? '';
          customerEmail = userDoc['email'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Show error to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white,fontSize: 17,fontFamily: "Mont"),
            ),
          ),
        );
      },
    );
  }

  // Method to submit the form data to Firestore
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) {
      // Form is invalid, stop submission
      return;
    }

    if (_selectedImages.isEmpty) {
      showErrorMessage('Please select at least one image.');
      return;
    }

    // Ensure the user has selected a warranty option
    if (warrantyOption == null) {
      showErrorMessage('Please select whether you have a warranty.');
      return;
    }

    if (proofImage == null && warrantyOption == 'Yes, it is under warranty') {
      showErrorMessage('Please upload proof of purchase.');
      return;
    }

    if (selectedLuggageType == null) {
      showErrorMessage('Please select a type of luggage.');
      return;
    }

    if (_brandController.text.trim().isEmpty) {
      showErrorMessage('Please enter the brand of luggage.');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      showErrorMessage('Please provide a description.');
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // Prepare data to store in Firestore
    final repairId = DateTime.now().millisecondsSinceEpoch.toString();
    final timestamp = DateTime.now();
    // Initialize a list to hold image URLs
    List<String> imageUrls = [];

    // Upload selected images
    for (var img in _selectedImages) {
      // Create a reference to the Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child(
          'images/${repairId}/${img.name}'); // Use img.name instead of basename(img.path)

      if (kIsWeb) {
        // For web, upload using bytes
        final byteData = await img.readAsBytes(); // Get bytes of the image
        UploadTask uploadTask =
            storageReference.putData(byteData); // Upload bytes directly
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl); // Add URL to the list
      } else {
        // For mobile/desktop
        UploadTask uploadTask = storageReference.putFile(File(img.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl); // Add URL to the list
      }
    }

    // Upload proof of purchase image, if exists
    String? proofImageUrl;
    var localProofImage = this.proofImage;
    if (localProofImage != null) {
      // Create a reference for the proof of purchase image
      Reference proofStorageReference = FirebaseStorage.instance.ref().child(
          'images/${repairId}/proof_of_purchase/${localProofImage.name}');

      // Handle upload
      if (kIsWeb) {
        final byteData = await proofImage?.readAsBytes();
        UploadTask uploadTask = proofStorageReference.putData(byteData!);
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL
        proofImageUrl = await taskSnapshot.ref.getDownloadURL();
      } else {
        UploadTask uploadTask =
            proofStorageReference.putFile(File(proofImage!.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL
        proofImageUrl = await taskSnapshot.ref.getDownloadURL();
      }
    }

    String fee;
    if (warrantyOption == 'Yes, it is under warranty') {
      fee = "Free";
    } else {
      fee = "To be determined";
    }


    // Prepare the luggage data with image URLs
    final luggageData = {
      'repairId': repairId,
      'userId': user.uid,
      'date': timestamp,
      'status': 'Pending',
      'customerFullName': customerFullName,
      'customerEmail': customerEmail,
      'images': imageUrls,
      'typeOfLuggage': selectedLuggageType,
      'brand': _brandController.text.trim(),
      'description': _descriptionController.text.trim(),
      'under_warranty': warrantyOption,
      'proofImage': proofImageUrl,
      'fee': fee,
    };

    try {
      await _firestore.collection('repair_request').add(luggageData);
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Luggage information submitted successfully!')),
      );
      // Clear the form after submission
      setState(() {
        _selectedImages.clear();
        proofImage = null;
        warrantyOption = null;
        selectedLuggageType = null;
        _brandController.clear();
        _descriptionController.clear();
      });
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting data: $e')),
      );
    } finally {
      // Close the loading dialog
      Navigator.of(context).pop();
    }
  }

  // Method to pick proof of purchase image
  Future<void> pickProofImage() async {
    final ImagePicker picker = ImagePicker();
    proofImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  // Method to pick images from gallery
  Future<void> pickImagesFromGallery() async {
    try {
      final List<XFile> selectedImages = await picker.pickMultiImage();
      if (selectedImages.length <= 5) {
        setState(() {
          _selectedImages.addAll(selectedImages);
        });
      } else if (selectedImages.length > 5) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You can only select up to 5 images.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  // Method to take pictures using camera
  Future<void> _takePhoto() async {
    if (kIsWeb) {
      await showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              'Camera is not supported on the web. Please choose images from gallery',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          );
        },
      );
    } else {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _selectedImages.add(photo);
        });
      }
    }
  }

  // Remove proof of purchase
  void removeProofImage() {
    setState(() {
      proofImage = null; // Remove the proof image
    });
  }

  @override
  void dispose() {
    _brandController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(children: [
      // Back button container
      Container(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
          label: const Text(
            "Back",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "Mont",
            ),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(50, 40),
            backgroundColor: Colors.blue[900],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      // Title
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
        child: Column(
          children: [
            Text(
              "Submit Repair Request",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: "june",
              ),
            ),

            const SizedBox(height: 15),

            // Add photos
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Add photos widget
                  MyPhotoWidget(
                    takePhoto: _takePhoto,
                    pickImagesFromGallery: pickImagesFromGallery,
                    selectedImages: _selectedImages,
                  ),

                  const SizedBox(height: 16),

                  // Choose luggage category
                  DropdownButtonFormField(
                    decoration:
                        InputStyles.commonInputDecoration("Type of Luggage"),
                    dropdownColor: Theme.of(context).colorScheme.inversePrimary,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Mont",
                        fontSize: 16),
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('Suitcase')),
                      DropdownMenuItem(value: '2', child: Text('Backpack')),
                      DropdownMenuItem(value: '3', child: Text('Garment Bag')),
                      DropdownMenuItem(value: '4', child: Text('Carry-On Bag')),
                      DropdownMenuItem(
                          value: '5', child: Text('Rolling Luggage')),
                      DropdownMenuItem(value: '6', child: Text('Briefcase')),
                      DropdownMenuItem(
                          value: '7', child: Text('Travel Organizer')),
                      DropdownMenuItem(
                          value: '8', child: Text('Hard Shell Luggage')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedLuggageType = value as String;
                      });
                    },
                    value: selectedLuggageType,
                  ),

                  const SizedBox(height: 16),

                  // Luggage brand
                  TextField(
                    controller: _brandController,
                    decoration: InputStyles.commonInputDecoration("Brand"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Mont",
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  TextField(
                    controller: _descriptionController,
                    decoration:
                        InputStyles.commonInputDecoration("Description"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Mont",
                    ),
                    maxLines: 4,
                  ),

                  const SizedBox(height: 16),

                  // Check for warranty
                  DropdownButtonFormField<String>(
                    decoration: InputStyles.commonInputDecoration(
                        "Is the item under warranty?"),
                    items: ['Yes, it is under warranty', 'No, it is not']
                        .map((option) => DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontFamily: "Mont",
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        warrantyOption = value;
                      });
                    },
                    value: warrantyOption,
                  ),

                  const SizedBox(height: 10),

                  // Upload proof of purchase
                  ProofOfPurchaseWidget(
                    takePhoto: _takePhoto,
                    pickProofImage: pickProofImage,
                    proofImage: proofImage,
                    warrantyOption: warrantyOption,
                    onRemove: removeProofImage,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: const Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Mont",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ])));
  }
}
