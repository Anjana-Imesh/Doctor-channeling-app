

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ViewDoctorsPage.dart';
import 'package:frontend/view_appointments_page.dart';
import 'package:frontend/login_page.dart';
import 'package:frontend/about_us_page.dart'; // ✅ About Us
import 'package:frontend/contact_us_page.dart'; // ✅ Contact Us

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // 👈 Replace with your image file path
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: buttonStyle,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Book an Appointment'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ViewDoctorsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: buttonStyle,
                    icon: const Icon(Icons.history),
                    label: const Text('My Appointments'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ViewAppointmentsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: buttonStyle,
                    icon: const Icon(Icons.info_outline),
                    label: const Text('About Us'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutUsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: buttonStyle,
                    icon: const Icon(Icons.contact_mail),
                    label: const Text('Contact Us'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContactUsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
