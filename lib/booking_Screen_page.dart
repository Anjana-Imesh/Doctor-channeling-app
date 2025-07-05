

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String location;
  final String time;
  final String fee;

  BookingScreen({
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.location,
    required this.time,
    required this.fee,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime? selectedDate;
  String? userName;
  final int maxAppointmentsPerDay = 10;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name'];
          });
        }
      }
    } catch (e, stackTrace) {
      print(' Error fetching user name: $e');
      print(' Stack trace:\n$stackTrace');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<bool> isFullyBooked(String doctorId, DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('appointmentDate', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return snapshot.docs.length >= maxAppointmentsPerDay;
    } catch (e, stackTrace) {
      print(' Error in isFullyBooked: $e');
      print(' Stack trace:\n$stackTrace');
      return false;
    }
  }

  Future<bool> hasUserAlreadyBooked(String userId, String doctorId, DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('appointmentDate', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e, stackTrace) {
      print(' Error checking existing booking: $e');
      print(' Stack trace:\n$stackTrace');
      return false;
    }
  }

  Future<int> getQueueNumber(String doctorId, DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('appointmentDate', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp')
          .get();

      return snapshot.docs.length + 1;
    } catch (e, stackTrace) {
      print(' Error getting queue number: $e');
      print(' Stack trace:\n$stackTrace');
      return 1;
    }
  }

  Future<void> bookAppointment() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user == null || userName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching user details')),
        );
        return;
      }

      bool alreadyBooked = await hasUserAlreadyBooked(
        user.uid, widget.doctorId, selectedDate!);
      if (alreadyBooked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You already have an appointment on this date with this doctor.')),
        );
        return;
      }

      bool fullyBooked = await isFullyBooked(widget.doctorId, selectedDate!);
      if (fullyBooked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This day is fully booked. Please choose another date.')),
        );
        return;
      }

      int queueNumber = await getQueueNumber(widget.doctorId, selectedDate!);

      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'specialization': widget.specialization,
        'location': widget.location,
        'time': widget.time,
        'fee': widget.fee,
        'userId': user.uid,
        'userName': userName,
        'appointmentDate': Timestamp.fromDate(selectedDate!),
        'timestamp': Timestamp.now(),
        'queueNumber': queueNumber,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked! Your queue number is $queueNumber')),
      );

      Navigator.pop(context);
    } catch (e, stackTrace) {
      print(' Error booking appointment: $e');
      print(' Stack trace:\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment with ${widget.doctorName}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.doctorName, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('Specialization: ${widget.specialization}'),
                      Text('Location: ${widget.location}'),
                      Text('Fee: ${widget.fee}'),
                      Text('Time: ${widget.time}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  selectedDate == null
                      ? 'Select Appointment Date'
                      : 'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: bookAppointment,
                child: const Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
