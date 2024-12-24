import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const ObjectDetectionScreen());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: ObjectDetectionScreen(),
//     );
//   }
// }

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  File? _image;
  final picker = ImagePicker();
  List<dynamic> _detections = [];
  final FlutterTts _flutterTts = FlutterTts();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future detectObjects() async {
    if (_image == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://172.20.10.4:7000/detect'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _image!.path,
      ),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      setState(() {
        _detections = jsonDecode(responseData.body)['detections'];
      });

      // Speak out the detected object names
      for (var detection in _detections) {
        final label = detection['label'];
        await speak('Detected: $label');
      }
    } else {
      setState(() {
        _detections = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOLOv10 Object Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.')
                : Stack(
                    children: [
                      Image.file(_image!),
                      ..._detections.map((detection) {
                        final box = detection['box'];
                        final label = detection['label'];
                        final score = detection['score'];
                        return Positioned(
                          left: box[0],
                          top: box[1],
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'Label: $label, Score: ${(score * 100).toStringAsFixed(2)}%',
                              style: const TextStyle(
                                backgroundColor: Colors.white,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
                textStyle: const TextStyle(fontSize: 24), // Font size
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 32), // Padding
              ),
              child: const Text('Take Photo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: detectObjects,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green, // Text color
                textStyle: const TextStyle(fontSize: 24), // Font size
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 32), // Padding
              ),
              child: const Text('Detect Objects'),
            ),
          ],
        ),
      ),
    );
  }
}
