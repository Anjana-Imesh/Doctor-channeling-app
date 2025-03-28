import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewAppointmentsPage extends StatelessWidget {
  const ViewAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: user == null
          ? const Center(child: Text("Please log in to view appointments"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('userId', isEqualTo: user.uid)
                  .orderBy('appointmentDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No appointments found'));
                }

                final appointments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = appointments[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text('Doctor: ${appointment['doctorName']}'),
                        subtitle: Text('Date: ${appointment['appointmentDate'].toDate()}'),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
