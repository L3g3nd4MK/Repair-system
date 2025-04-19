import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
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
                  'Terms & Conditions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Introduction
                const Text(
                  'By using Matrix Luggage repair services, you agree to the following Terms and Conditions:\n',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                // Service Agreement
                _buildSectionTitle('Service Agreement'),
                _buildSectionContent(
                  'Matrix agrees to inspect and repair your luggage as per the repair request submitted. '
                      'A free estimate will be provided, and no work will begin without customer approval.',
                ),

                // Repair Warranty
                _buildSectionTitle('Repair Warranty'),
                _buildSectionContent(
                  'We offer a 6-month warranty on repairs. This covers defects in parts and workmanship. '
                      'The warranty does not cover wear and tear, misuse, or damage caused by third parties.',
                ),

                // Turnaround Time
                _buildSectionTitle('Turnaround Time'),
                _buildSectionContent(
                  'While we strive to complete repairs within the specified timeframe, delays may occur due to parts availability or unforeseen circumstances.',
                ),

                // Liability
                _buildSectionTitle('Liability'),
                _buildSectionContent(
                  'Matrix is not responsible for damage or loss of luggage beyond the repair scope or for items '
                      'left inside luggage. Customers are advised to remove all valuables before pick-up.',
                ),

                // Abandoned Luggage
                _buildSectionTitle('Abandoned Luggage'),
                _buildSectionContent(
                  'Luggage not collected within 90 days of notification of completion will be considered abandoned, '
                      'and Matrix reserves the right to dispose of or recycle such items.',
                ),

                // Changes to Terms
                _buildSectionTitle('Changes to Terms'),
                _buildSectionContent(
                  'We reserve the right to modify these terms at any time. Updated terms will be posted on our website.\n',
                ),

                // Contact Information
                _buildSectionTitle('Contact Us'),
                const Text(
                  'For any questions or concerns, please contact us at:\n'
                      'Email: info@matrix.co.za\n'
                      'Telephonic Support: 051 687 2130',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      ),
    );
  }
}
