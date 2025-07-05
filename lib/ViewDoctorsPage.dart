
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/booking_Screen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: const ViewDoctorsPage(),
    );
  }
}

class ViewDoctorsPage extends StatefulWidget {
  const ViewDoctorsPage({super.key});

  @override
  State<ViewDoctorsPage> createState() => _ViewDoctorsPageState();
}

class _ViewDoctorsPageState extends State<ViewDoctorsPage> {
  String selectedSpecialization = 'All';
  String selectedLocation = 'All';

  final specializations = ['All', 'Neurologist', 'Dermatologist', 'Psychiatrist', 'Cardiologist'];
  final locations = ['All', 'Colombo', 'Kalutara', 'Gampaha'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Doctors'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Specialization'),
                    value: selectedSpecialization,
                    items: specializations.map((spec) {
                      return DropdownMenuItem(value: spec, child: Text(spec));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedSpecialization = value!);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Location'),
                    value: selectedLocation,
                    items: locations.map((loc) {
                      return DropdownMenuItem(value: loc, child: Text(loc));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedLocation = value!);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No doctors found.'));
                }

                var doctors = snapshot.data!.docs.where((doc) {
                  final specializationMatch = selectedSpecialization == 'All' || doc['specialization'] == selectedSpecialization;
                  final locationMatch = selectedLocation == 'All' || doc['location'] == selectedLocation;
                  return specializationMatch && locationMatch;
                }).toList();

                if (doctors.isEmpty) {
                  return const Center(child: Text('No matching doctors.'));
                }

                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    var doc = doctors[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12.0),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(doc['imageUrl']),
                          onBackgroundImageError: (_, __) => const Icon(Icons.person),
                        ),
                        title: Text(
                          "Dr. ${doc['name']}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("Specialization: ${doc['specialization']}"),
                            Text("Availability: ${doc['availability']}"),
                            Text("Location: ${doc['location']}"),
                            Text("Time: ${doc['timeFrom']} - ${doc['timeTo']}"),
                            Text("Fee: Rs. ${doc['fee']}"),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                doctorId: doc.id,
                                doctorName: "Dr. ${doc['name']}",
                                specialization: doc['specialization'],
                                location: doc['location'],
                                time: "${doc['timeFrom']} - ${doc['timeTo']}",
                                fee: doc['fee'].toString(),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
