import 'package:flutter/material.dart';

class FrequentlyAskedQ extends StatelessWidget {
  const FrequentlyAskedQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildSectionTitle('1. What type of luggage do you repair?'),
                _buildSectionContent(
                  'We repair all types of luggage, including suitcases, carry-ons, duffel bags, and more.'
                  ' We work with various brands and models.',
                ),

                _buildSectionTitle('2. How long does the repair process take?'),
                _buildSectionContent(
                  'Typical repairs take 5-10 business days, depending'
                  ' on the extent of the damage and the availability of parts.',
                ),

                _buildSectionTitle('3. Do you offer a warranty on repairs?'),
                _buildSectionContent(
                    'Yes, we offer a 6-month warranty on all repairs. This covers the workmanship and parts used.'),

                _buildSectionTitle('4. How much will my repair cost?'),
                _buildSectionContent(
                  'Repair costs vary based on the type of damage.'
                      ' We provide a free estimate once the luggage has been inspected. '
                      'If your luggage is under warranty, you will not have to pay a fee.',
                ),

                _buildSectionTitle('5. Do you offer pickup and delivery services?'),
                _buildSectionContent(
                  'Yes, we offer pickup and delivery services for a fixed fee within our service area.',
                ),

                _buildSectionTitle('6. What if my luggage is beyond repair?'),
                _buildSectionContent(
                  'If your luggage cannot be repaired, we will notify you, '
                      'and no charges will apply unless a diagnostic fee was agreed upon.',
                ),

                _buildSectionTitle('7. Can I track the status of my repair?'),
                _buildSectionContent(
                  'Yes, you can track the status of your repair via the bookings page on your dashboard.',
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        content,
        style: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
