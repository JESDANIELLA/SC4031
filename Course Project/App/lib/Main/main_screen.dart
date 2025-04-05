import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'package:starsearch_fixed/CommonML/PredictionResult.dart';
import '../Main/NavigationManager.dart';
import '../Main/drawer.dart';
import '../Main/TabScreen.dart';

class RemoteML extends StatefulWidget {
  const RemoteML({super.key});
  static const routeName = '/root';

  @override
  State<RemoteML> createState() => _RemoteMLState();
}

class _RemoteMLState extends State<RemoteML> {
  File? image;
  Future<RemotePrediction>? prediction;
  RemotePrediction? predictionResult;

  Future<void> getImageFromGallery() async {
    final picker = ImagePicker();
    final photosStatus = await Permission.photos.request();
    final storageStatus = await Permission.storage.request();

    if (photosStatus.isGranted || storageStatus.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (!mounted) return;
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          NavigationManager.noImgError(context);
        }
      });
    } else {
      if (!mounted) return;
      NavigationManager.noImgError(context);
      openAppSettings();
    }
  }

  Future<RemotePrediction> remoteML(File selectedImage) async {
    var url = Uri.parse('http://34.143.199.11:8080/upload');
    final request = http.MultipartRequest("POST", url);
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(
      http.MultipartFile(
        'image',
        selectedImage.readAsBytes().asStream(),
        selectedImage.lengthSync(),
        filename: selectedImage.path.split('/').last,
      ),
    );

    request.headers.addAll(headers);

    var response = await request.send();
    var res = await http.Response.fromStream(response);

    if (res.statusCode == 201 || res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      return RemotePrediction.fromJson(jsonData);
    } else {
      throw Exception('Failed to load prediction: ${res.statusCode} ${res.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Fruit Classifier",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(43, 21, 12, 12),
            fontFamily: 'Helvetica',
          ),
        ),
      ),
      drawer: MainDrawer(),
      bottomNavigationBar: TabScreen(1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Fruit Classification App",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 81, 15, 172),
                fontFamily: 'Helvetica',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Classify images into 10 different fruit types",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(179, 42, 7, 213),
                fontFamily: 'Helvetica',
              ),
            ),
            const SizedBox(height: 30),

            _buildGlassButton(
              label: 'Choose from Gallery',
              onTap: () async => await getImageFromGallery(),
            ),
            const SizedBox(height: 24),
            _buildGlassButton(
              label: 'Run Classification',
              onTap: () {
                if (image == null) {
                  NavigationManager.noImgError(context);
                  return;
                }
                setState(() {
                  prediction = remoteML(image!);
                });
              },
            ),
            const SizedBox(height: 24),

            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(image!, fit: BoxFit.cover),
              ),

            const SizedBox(height: 20),

            if (prediction != null)
              FutureBuilder<RemotePrediction>(
                future: prediction,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _statusCard("Processing...");
                  } else if (snapshot.hasData) {
                    predictionResult = snapshot.data;
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        _resultCard(snapshot.data!),
                        const SizedBox(height: 8),
                        _timestampText(snapshot.data!.timeStamp),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return _statusCard("Something went wrong.");
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.grey.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Helvetica',
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _statusCard(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Helvetica',
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _resultCard(RemotePrediction prediction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dataRow("Class", prediction.classname),
          const SizedBox(height: 12),
          _dataRow("Confidence", prediction.accuracy),
          const SizedBox(height: 12),
          _dataRow("Filename", prediction.filename),
        ],
      ),
    );
  }

  Widget _timestampText(String timestamp) {
    return Text(
      "Uploaded At: $timestamp",
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.grey,
        fontFamily: 'Helvetica',
        fontSize: 13,
      ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label:",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
            fontFamily: 'Helvetica',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: 'Helvetica',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
