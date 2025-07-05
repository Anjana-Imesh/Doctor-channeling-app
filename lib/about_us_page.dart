
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static const LatLng hqLocation = LatLng(6.936117, 79.845898); // Colombo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Our App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "We are Medizone (PVT) Ltd. Sri Lanka's number one healthcare service provider."
                ' Our app helps patients book appointments with trusted doctors, '
                'view their medical schedules, and manage their healthcare journey with ease.\n\n'
                'Features include:\n'
                '• Doctor search by specialization and location\n'
                '• Online appointment booking\n'
                '• Queue number notifications\n'
                '• Easy appointment cancelling feature\n'
                '• Appointment history management\n\n'
                'Thank you for using our app!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Our Headquarters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('Colombo, Sri Lanka'),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: hqLocation,
                      zoom: 14,
                    ),
                    markers: {
                      const Marker(
                        markerId: MarkerId('hq'),
                        position: hqLocation,
                        infoWindow: InfoWindow(title: 'Medizone HQ'),
                      )
                    },
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
