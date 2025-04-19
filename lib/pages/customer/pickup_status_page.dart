import 'package:flutter/material.dart';

class PickupStatusPage extends StatelessWidget {
  final List<Map<String, dynamic>> repairRequests;

  const PickupStatusPage({super.key, required this.repairRequests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pickup Requests"),
        backgroundColor: Colors.blue[900],
      ),
      body: repairRequests.isEmpty
          ? const Center(
              child: Text(
                'No repair requests found.',
                style: TextStyle(fontSize: 18, fontFamily: "Mont"),
              ),
            )
          : ListView.builder(
              itemCount: repairRequests.length,
              itemBuilder: (context, index) {
                final request = repairRequests[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            "Request ID: ${request['id']}",
                            style: const TextStyle(
                                fontFamily: "Mont", fontSize: 15),
                          ),
                          subtitle: Text(
                            "Status: ${request['status']}",
                            style: const TextStyle(
                                fontFamily: "Mont", fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Pickup logic
                              if (request['status'] == 'Approved') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Schedule Pickup",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontFamily: "Mont"),
                                      ),
                                      content: const Text(
                                        "Are you sure you want to schedule a pickup for this request?",
                                        style: TextStyle(
                                          fontFamily: "Mont",

                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontFamily: "Mont",
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "Confirm",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontFamily: "Mont",
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(
                                              context,
                                              '/customer_pickup_page',
                                              arguments: request['id'],
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // If not approved, show a message
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        backgroundColor: Colors.deepPurple,
                                        title: Center(
                                          child: Text(
                                            'Pickup can only be scheduled for approved requests.',
                                            style: TextStyle(
                                              fontFamily: "Mont",
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                            ),
                            child: const Text(
                              "Schedule Pickup",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
