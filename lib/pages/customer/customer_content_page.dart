import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/pages/customer/customer_delivery_page.dart';
import 'package:final_app/pages/customer/delivery_status_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pickup_status_page.dart';
import 'customer_repair_page.dart';

class CustomerContentPage extends StatefulWidget {
  const CustomerContentPage({super.key});

  @override
  State<CustomerContentPage> createState() => _CustomerContentPageState();
}

class _CustomerContentPageState extends State<CustomerContentPage> {
  // Slightly reduce the card size
  final PageController _controller = PageController(viewportFraction: 0.80);
  // get repair requests
  List<Map<String, dynamic>> repairRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserRepairRequests(); // Fetch repair requests when the widget initializes
  }

  Future<void> fetchUserRepairRequests() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch repair requests from Firestore for the current user
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('repair_request')
            .where('userId', isEqualTo: user.uid) // Filter by user ID
            .get();

        // Convert the fetched documents into a list of maps
        repairRequests = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'status': doc['status'],
          };
        }).toList();
      } catch (e) {
        // Handle errors if needed
        print('Error fetching repair requests: $e');
      }
      setState(() {
        isLoading = false; // Update loading state after fetching data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildCard(String title, String description, Widget nextPage) =>
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.85, // Responsive width
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[900]!, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: "nunito",
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontFamily: "Mont",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => nextPage),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "OPEN SERVICE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "nunito",
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );

    return Scaffold(
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [
          buildCard(
            "REPAIR",
            'Book your luggage to get repaired by our experts',
            const CustomerRepairPage(),
          ),
          buildCard(
            "PICKUP",
            'Schedule a pickup for your luggage after your repair request has been approved',
            PickupStatusPage(repairRequests: repairRequests),
          ),
          buildCard(
            "DELIVERY",
            'Get your repaired luggage delivered back to you',
            DeliveryStatusPage(repairRequests: repairRequests),
          ),
        ],
      ),
    );
  }
}
