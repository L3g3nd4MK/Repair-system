import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                  'Privacy Policy',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildSectionTitle('What General Information do we collect?'),
                _buildSectionContent(
                  'Certain information is collected through the way you interact with our site as well as information about how you arrived at our site. This information is generally the following:\n'
                      '•	IP Address\n'
                      '•	Web Browser\n'
                      '•	Cookies\n'
                      '•	About your Device',
                ),

                _buildSectionTitle('What General Information is Collected when you Register?'),
                _buildSectionContent(
                  'At the time of registering on the site, you will be asked to complete certain information like:\n'
                      '•	Name\n'
                      '•	Surname\n'
                      '•	Residential Address\n'
                      '•	Delivery Address Details if different from your Residential Address.\n'
                      '•	Contact Details-email address and Contact Phone Number\n'
                      'This information is stored and linked to the username that you have supplied at the time of registration.',
                ),

                _buildSectionTitle('Use of the Information Collected'),
                _buildSectionContent(
                  'The use of the General Information above is used for the finalisation and dispatch of your order to the'
                      ' delivery address as indicated by yourself relating to that particular order.\n'
                      'This order information is stored with all the required product information against an allocated Order Number.\n'
                      'This Order Number and the order detail is linked to your user account.\n'
                      'This order information can be accessed at any time by yourself by logging into your user account.\n'
                      'The information collected may be used in the identification of potential fraudulent transactions.\n'
                      'We unfortunately live in a world where cyber-crime is an everyday occurrence.',
                ),

                _buildSectionTitle('Protection of Personal Information'),
                _buildSectionContent(
                  'We comply with South Africa’s Protection of Personal Information Act of 2013 (“POPI”). '
                      'We undertake that all Employees are made aware of the said act and that they will comply'
                      ' so that any Personal Information supplied by you to us is only handled in the way as indicated in this document.',
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
