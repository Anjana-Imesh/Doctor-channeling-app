/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/add_new_task.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/widgets/date_selector.dart';
import 'package:frontend/widgets/task_card.dart';
import 'package:frontend/login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to LoginPage and remove the current page from the stack
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewTask(),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.add,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const DateSelector(),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("tasks")
                  .where('creator',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Text('No data here :(');
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(index),
                        onDismissed: (direction) async{
                          if(direction == DismissDirection.endToStart){
                            await FirebaseFirestore.instance
                            .collection("tasks")
                            .doc(snapshot.data!.docs[index].id)
                            .delete();
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: TaskCard(
                                color: const Color.fromRGBO(246, 222, 194, 1),
                                headerText:
                                    snapshot.data!.docs[index].data()['title'],
                                descriptionText: snapshot.data!.docs[index]
                                    .data()['description'],
                                scheduledDate: snapshot.data!.docs[index]
                                    .data()['date']
                                    .toString(),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: strengthenColor(
                                  const Color.fromRGBO(246, 222, 194, 1),
                                  0.69,
                                ),
                              image: snapshot.data!.docs[index]
                                          .data()['imageURL'] ==
                                      null
                                  ? null
                                  : DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data!.docs[index]
                                            .data()['imageURL'],
                                      ),
                                    ),  
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                '10:00AM',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

 

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Doctors')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(doc['imageUrl']),
                  ),
                  title: Text(doc['name']),
                  subtitle: Text(doc['specialty']),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(doctorId: doc.id, doctorName: doc['name']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BookingScreen extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BookingScreen({required this.doctorId, required this.doctorName});

  Future<void> bookAppointment() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': doctorId,
        'doctorName': doctorName,
        'userId': user.uid,
        'timestamp': Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment with $doctorName')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await bookAppointment();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment booked!')));
            Navigator.pop(context);
          },
          child: Text('Confirm Booking'),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/add_new_task.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/widgets/date_selector.dart';
import 'package:frontend/widgets/task_card.dart';
import 'package:frontend/login_page.dart';
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Doctors'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(doc['imageUrl']),
                  ),
                  title: Text(doc['name']),
                  subtitle: Text(doc['specialty']),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(doctorId: doc.id, doctorName: doc['name']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/*
class BookingScreen extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BookingScreen({required this.doctorId, required this.doctorName});

  Future<void> bookAppointment() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': doctorId,
        'doctorName': doctorName,
        'userId': user.uid,
        'userEmail': user.email,
        'timestamp': Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment with $doctorName')),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange, // Orange for View Appointments
    foregroundColor: Colors.black, // Black text
  ),
          onPressed: () async {
            await bookAppointment();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment booked!')));
            Navigator.pop(context);
          },
          child: Text('Confirm Booking'),
        ),
      ),
    );
  }
}

*/

