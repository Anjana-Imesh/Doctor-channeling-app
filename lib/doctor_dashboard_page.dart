

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No appointments found."));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final data = appointment.data() as Map<String, dynamic>;

              final DateTime date = data['appointmentDate'].toDate();
              final String formattedDate = DateFormat('dd MMM yyyy').format(date);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'Patient: ${data['userName']}',
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('Date: $formattedDate', style: textTheme.bodyMedium),
                      Text('Time: ${data['time']}', style: textTheme.bodyMedium),
                      Text('Queue Number: ${data['queueNumber']}', style: textTheme.bodyMedium),
                      Text('Location: ${data['location']}', style: textTheme.bodyMedium),
                      Text('Fee: Rs. ${data['fee']}', style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
