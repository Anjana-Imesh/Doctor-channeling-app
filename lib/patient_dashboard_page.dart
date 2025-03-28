/*
import 'package:flutter/material.dart';
import 'package:frontend/home_page.dart';
import 'package:frontend/view_appointments_page.dart';
class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()) // Redirect to Login Page
    );
              },
              child: Text('Book an Appointment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ViewAppointmentsPage()) // Redirect to Login Page
    );
              },
              child: Text('View Existing Appointments'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home_page.dart';
import 'package:frontend/view_appointments_page.dart';
import 'package:frontend/login_page.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  // Logout function
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // Redirect to Login Page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Call logout function
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange, // Orange for View Appointments
    foregroundColor: Colors.black, // Black text
  ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
              child: const Text('Book an Appointment'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange, // Orange for View Appointments
    foregroundColor: Colors.black, // Black text
  ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewAppointmentsPage()),
                );
              },
              child: const Text('View Existing Appointments'),
            ),
          ],
        ),
      ),
    );
  }
}
