import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const ColorDetectionApp());
}

class ColorDetectionApp extends StatefulWidget {
  const ColorDetectionApp({super.key});

  @override
  _ColorDetectionAppState createState() => _ColorDetectionAppState();
}

class _ColorDetectionAppState extends State<ColorDetectionApp> {
  File? _image;
  String _detectedColor = "Undefined";
  bool _isLoading = false;

  final picker = ImagePicker();
  final FlutterTts flutterTts = FlutterTts();

  // call backend ip
  final String backendUrl = 'http://172.20.10.4:5000/detect_color';

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });

      File imageFile = File(pickedFile.path);
      String base64Image = base64Encode(imageFile.readAsBytesSync());

      // Send the image to the backend
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _detectedColor = data['color'];
          _image = imageFile;
          _isLoading = false;
        });
        _speakColor(_detectedColor);
      } else {
        setState(() {
          _detectedColor = "Error detecting color";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _speakColor(String color) async {
    await flutterTts.speak("Detected color is $color");
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Widget _buildImage() {
    if (_image != null) {
      return Image.file(
        _image!,
        height: 300,
      );
    } else {
      return const Text(
        "No image selected.",
        style: TextStyle(fontSize: 18),
      );
    }
  }

  Widget _buildDetectedColor() {
    return Text(
      "Detected Color: $_detectedColor",
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetectButton() {
    return ElevatedButton.icon(
      onPressed: _getImage,
      icon: const Icon(Icons.camera_alt),
      label: const Text("Capture Image"),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildLoading() {
    return _isLoading
        ? const Column(
            children: [
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Detection',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Color Detection"),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImage(),
                const SizedBox(height: 20),
                _buildDetectedColor(),
                _buildLoading(),
                const SizedBox(height: 20),
                _buildDetectButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
