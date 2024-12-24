import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'setting_screen.dart';
import 'color_detector.dart'; // Make sure to import the ColorDetectionApp file
import 'money_detector..dart';
import 'door_detector.dart';

class DashboardScreen extends StatelessWidget {
  final String userId;

  DashboardScreen({super.key, required this.userId}) {
    print('DashboardScreen initialized with userId: $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Eye Care'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingScreen(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button 1: Color Detector
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ColorDetectionApp(), // Navigate to the color detector page
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize:
                    const Size(200, 60), // Change button color to yellow
              ),
              child: const Text('Color Detector'),
            ),
            const SizedBox(height: 20),

            // Button 2: Currency Detector
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ObjectDetectionScreen(), // Navigate to the color detector page
                  ),
                );
              },


              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize:
                    const Size(200, 60), // Change button color to yellow
              ),
              child: const Text('Currency Detector'),
            ),
            const SizedBox(height: 20),

            // Button 3: Door Detector
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LaunchUnityAppButton(), // Navigate to the color detector page
                  ),
                );

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize:
                    const Size(200, 60), // Change button color to yellow
              ),
              child: const Text('Door Detector'),
            ),
            const SizedBox(height: 50),

            // Profile Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: userId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 61, 240, 6),
              ),
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
