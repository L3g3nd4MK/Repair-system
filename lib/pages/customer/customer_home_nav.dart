import 'package:final_app/pages/customer/customer_settings_page.dart';
import 'package:final_app/pages/customer/faq_page.dart';
import 'package:final_app/pages/customer/terms_conditions_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'customer_account_page.dart';
import 'customer_booking_page.dart';
import 'customer_content_page.dart';
import 'customer_messages_page.dart';

class CustomerHomeNav extends StatefulWidget {
  const CustomerHomeNav({super.key});

  @override
  State<CustomerHomeNav> createState() => _CustomerHomeNavState();
}

class _CustomerHomeNavState extends State<CustomerHomeNav> {
  //sign user out method
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  int selectedIndex = 0;

  final List<Widget> pages = [
    const CustomerContentPage(),
    const CustomerBookingPage(),
    CustomerMessagesPage(),
    const CustomerAccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.blue[900],
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
            children: [
              _buildDrawerHeader(),
              _buildDrawerItem(
                icon: FontAwesomeIcons.house,
                text: 'Home',
                index: 0,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),
              _buildDrawerItem(
                icon: FontAwesomeIcons.calendar,
                text: 'My Bookings',
                index: 1,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
              _buildDrawerItem(
                icon: FontAwesomeIcons.solidMessage,
                text: 'Messages',
                index: 2,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedIndex = 2;
                  });
                },
              ),
              _buildDrawerItem(
                icon: FontAwesomeIcons.circleUser,
                text: 'Account',
                index: 3,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedIndex = 3;
                  });
                },
              ),
              _buildDrawerItem(
                icon: FontAwesomeIcons.fileContract,
                text: 'Terms & Conditions',
                index: 4,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsConditionsPage()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: FontAwesomeIcons.circleInfo,
                text: 'FAQs',
                index: 5,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FrequentlyAskedQ()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: FontAwesomeIcons.gear,
                text: 'Settings',
                index: 6,
                onTap: () {
                  Navigator.pushNamed(context, '/customer_settings_page');
                },
              ),
              _buildDrawerItem(
                icon: FontAwesomeIcons.rightFromBracket,
                text: 'Logout',
                index: 7,
                onTap: () {
                  signUserOut();
                },
              ),

              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'App version 1.0.0',
                  style: TextStyle(color: Colors.white54, fontFamily: "Mont",),
                ),
              ),
              const SizedBox(height: 20),
              _buildSocialMediaIcons(),

            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.tertiary,
          size: 30,
        ),
        title: Text(
          "Matrix",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 50,
            fontFamily: "june",
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Theme.of(context).colorScheme.tertiary,
                size: 30,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: const CustomerSettingsPage(),
                    ),
                  ),
                );
              }),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.blueAccent,
            )
          ],
        ),
        child: GNav(
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.calendar_today, text: "Bookings"),
            GButton(icon: Icons.messenger, text: "Messages"),
            GButton(icon: Icons.account_circle, text: "Account"),
          ],
          activeColor: Colors.white,
          color: Colors.white,
          tabBackgroundColor: Colors.blue[900]!,
          padding: const EdgeInsets.all(12),
          curve: Curves.bounceIn,
          iconSize: 28,
          gap: 5,
          duration: const Duration(milliseconds: 500),
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
      body: pages[selectedIndex],
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue[900],
      ),
      child: const Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('lib/assets/logo1.jpg'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Matrix',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Mont",
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Gopal Luggage Repair System',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontFamily: "Mont",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 38,),
            onPressed: () {

            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.white, size: 38,),
            onPressed: () {

            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.white, size: 38,),
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    required int index,
  }) {
    bool isSelected = selectedIndex == index;
    return Container(
        width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(15)
        ),

        child: ListTile(
          leading: FaIcon(icon, color: isSelected ? Colors.blue[900] : Colors.white,),
          title: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.blue[900] : Colors.white, fontSize: 16, fontFamily: "Mont",),
          ),
          onTap: onTap,
        )
    );

  }
}

