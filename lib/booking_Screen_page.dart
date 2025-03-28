/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  BookingScreen({required this.doctorId, required this.doctorName});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime? selectedDate;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)), // Limit to 1 year
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to book appointment
  Future<void> bookAppointment() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'userId': user.uid,
        'userEmail': user.email,
        'appointmentDate': selectedDate, // Store selected date
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment with ${widget.doctorName}')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
              ),
              onPressed: () => _selectDate(context),
              child: Text(selectedDate == null
                  ? 'Select Appointment Date'
                  : 'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
              ),
              onPressed: bookAppointment,
              child: Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  BookingScreen({required this.doctorId, required this.doctorName});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime? selectedDate;
  String? userName; // Store the patient's name

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Fetch user's name from Firestore
  Future<void> _fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name']; // Get the name from Firestore
        });
      }
    }
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)), // Limit to 1 year
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to book appointment
  Future<void> bookAppointment() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    User? user = _auth.currentUser;
    if (user != null && userName != null) {
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'userId': user.uid,
        'userName': userName, // Correctly using the fetched name
        'appointmentDate': Timestamp.fromDate(selectedDate!), // Store selected date
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked!')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment with ${widget.doctorName}')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
              ),
              onPressed: () => _selectDate(context),
              child: Text(selectedDate == null
                  ? 'Select Appointment Date'
                  : 'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
              ),
              onPressed: bookAppointment,
              child: Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
