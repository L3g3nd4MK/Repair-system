import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Booking {
  final String serviceType;
  final String date;
  final String status;
  final String deliveryAddress;
  final String preferredDate;
  final String specialInstruction;

  Booking({
    required this.serviceType,
    required this.date,
    required this.status,
    required this.deliveryAddress,
    required this.preferredDate,
    required this.specialInstruction,
  });
}

class CustomerDeliveryPage extends StatefulWidget {
  final String requestId;

  const CustomerDeliveryPage({super.key, required this.requestId});

  @override
  State<CustomerDeliveryPage> createState() => _CustomerDeliveryPageState();
}

class _CustomerDeliveryPageState extends State<CustomerDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  final _deliveryAddressController = TextEditingController();
  final _specialInstructionController = TextEditingController();
  DateTime? _preferredDate;
  final user = FirebaseAuth.instance.currentUser!;

  Future<Map<String, String>> _getUserInfo() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final fullName = userDoc['fullName'];
      final email = userDoc['email'];
      return {
        'fullName': fullName,
        'email': email,
      };
    } catch (error) {
      print("Error fetching user info: $error");
      return {
        'fullName': '',
        'email': '',
      };
    }
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_preferredDate == null) {
        _showSnackBar('Please select a preferred date.');
      } else {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissing the dialog
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        final formattedPreferredDate = DateFormat('yyyy-MM-dd').format(_preferredDate!);
        final deliveryId = generateDeliveryId();

        // Creating a Booking instance
        final booking = Booking(
          serviceType: "Delivery",
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          status: "Scheduled for Delivery",
          deliveryAddress: _deliveryAddressController.text,
          preferredDate: formattedPreferredDate,
          specialInstruction: _specialInstructionController.text,
        );

        try {
          // Fetch user information
          Map<String, String> userInfo = await _getUserInfo();
          // Saving to Firestore
          await FirebaseFirestore.instance.collection('deliveries').doc(widget.requestId).set({
            'userId': user.uid,
            'fullName': userInfo['fullName'],
            'email': userInfo['email'],
            'deliveryId': deliveryId,
            'serviceType': booking.serviceType,
            'delivery_request_date': booking.date,
            'status': booking.status,
            'deliveryAddress': booking.deliveryAddress,
            'preferredDate': booking.preferredDate,
            'specialInstruction': booking.specialInstruction,
            'createdAt': Timestamp.now(),
          });

          // Update the status of the repair request
          await updateRepairRequestStatus(widget.requestId);

          // Dismiss the loading dialog and show success dialog
          Navigator.of(context).pop();
          _showDialog();
        } catch (error) {
          // Handle Firestore errors
          Navigator.of(context).pop();
          _showSnackBar('Error scheduling delivery: $error');
        }
      }
    }
  }

  Future<void> updateRepairRequestStatus(String repairRequestId) async {
    try {
      // Get a reference to the repair_request collection
      CollectionReference repairRequests = FirebaseFirestore.instance.collection('repair_request');

      // Update the status to 'scheduled for delivery'
      await repairRequests.doc(repairRequestId).update({
        'status': 'Scheduled for delivery',
      });

      print("Repair request status updated to 'scheduled for delivery'");
    } catch (e) {
      // Handle errors (e.g., show an error message)
      print("Error updating repair request status: $e");
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600]),
                const SizedBox(width: 15),
                Text(
                  'Delivery Scheduled',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: "Mont",
                  ),
                ),
              ],
            ),
          ),
          content: Text(
            'Your delivery has been scheduled successfully.',
            style: TextStyle(color: Colors.grey[800], fontSize: 18, fontFamily: "Nunito"),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[900],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Nunito",
                ),
              ),
              onPressed: () => Navigator.popAndPushNamed(context, 'delivery_status_page'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Nunito'),
        ),
        backgroundColor: Colors.red[900],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            _buildBackButton(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          label: const Text(
            "Back",
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Mont"),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "Schedule Delivery",
            style: TextStyle(
              color: Colors.blue[900]!,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              fontFamily: "june",
            ),
          ),
          const SizedBox(height: 10),
          _buildTextField(_deliveryAddressController, 'Delivery Address', Icons.location_on, 2),
          const SizedBox(height: 16),
          _buildDateAndTimeButtons(),
          const SizedBox(height: 16),
          _buildTextField(_specialInstructionController, 'Special Instruction (optional)', null, 4, isOptional: true),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Note: Your item will be delivered before 5pm",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData? icon, int maxLines, {bool isOptional = false}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TextFormField(
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Mont"
            ),
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon,color: Colors.blue[900],) : null,
              labelText: label,
              labelStyle: TextStyle(
                  color: Colors.blue[900],
                  fontFamily: "Mont",
                  fontWeight: FontWeight.bold),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
              fillColor: Colors.white,
              filled: true,
            ),
            validator: (value) {
              if (!isOptional && (value == null || value.isEmpty)) {
                return 'Please enter $label';
              }
              return null; // No validation error
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTimeButtons() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Row(
        children: [
          Expanded(
            child: _buildDateButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025),
          );
          setState(() {
            _preferredDate = pickedDate;
          });
        },
        style: _elevatedButtonStyle(),
        child: Row(
          children: [
            const Icon(Icons.date_range, color: Colors.white),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                _preferredDate == null ? 'Preferred Date' : DateFormat('yyyy-MM-dd').format(_preferredDate!),
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, fontFamily: "Nunito"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 50,
      constraints: const BoxConstraints(maxWidth: 800),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: _elevatedButtonStyle(),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Text(
              "Submit",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Nunito", color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }


  ButtonStyle _elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blue[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  String generateDeliveryId() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(8, (index) => characters[random.nextInt(characters.length)]).join();
  }
}
