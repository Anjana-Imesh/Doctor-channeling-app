

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewAppointmentsPage extends StatelessWidget {
  const ViewAppointmentsPage({super.key});

  Future<void> cancelAppointmentAndUpdateQueue({
    required BuildContext context,
    required String appointmentId,
    required String doctorId,
    required DateTime appointmentDate,
    required int cancelledQueueNumber,
  }) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      DocumentReference docRef = FirebaseFirestore.instance.collection('appointments').doc(appointmentId);
      batch.delete(docRef);

      DateTime startOfDay = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('appointmentDate', isLessThan: Timestamp.fromDate(endOfDay))
          .where('queueNumber', isGreaterThan: cancelledQueueNumber)
          .orderBy('queueNumber')
          .get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        int currentNumber = doc['queueNumber'];
        batch.update(doc.reference, {'queueNumber': currentNumber - 1});
      }

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment cancelled successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cancelling: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
      ),
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
                    DateTime appointmentDate = appointment['appointmentDate'].toDate();
                    DateTime processedTime = appointment['timestamp'].toDate();

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment['doctorName'],
                              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Date: ${DateFormat('dd MMM yyyy').format(appointmentDate)}'),
                            Text('Time: ${appointment['time']}'),
                            Text('Specialization: ${appointment['specialization']}'),
                            Text('Location: ${appointment['location']}'),
                            Text('Fee: Rs. ${appointment['fee']}'),
                            Text('Queue Number: ${appointment['queueNumber']}'),
                            Text(
                              'Processed On: ${DateFormat('dd MMM yyyy – hh:mm a').format(processedTime)}',
                              style: textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  bool? confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Cancel Appointment'),
                                      content: const Text('Are you sure you want to cancel this appointment?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await cancelAppointmentAndUpdateQueue(
                                      context: context,
                                      appointmentId: appointment.id,
                                      doctorId: appointment['doctorId'],
                                      appointmentDate: appointmentDate,
                                      cancelledQueueNumber: appointment['queueNumber'],
                                    );
                                  }
                                },
                                icon: const Icon(Icons.cancel_outlined),
                                label: const Text('Cancel'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.error,
                                  foregroundColor: theme.colorScheme.onError,
                                ),
                              ),
                            ),
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
