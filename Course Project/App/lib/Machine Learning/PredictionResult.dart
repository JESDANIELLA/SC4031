import 'package:flutter/material.dart';

/// Show a dialog with the prediction result message.
void showPredictionResultDialog(BuildContext context, String message) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Prediction Result'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// Model class to represent a prediction result from the server.
class RemotePrediction {
  final String classname;
  final String accuracy;
  final String timeStamp;
  final String filename;

  RemotePrediction({
    required this.filename,
    required this.classname,
    required this.accuracy,
    required this.timeStamp,
  });

  factory RemotePrediction.fromJson(Map<String, dynamic> json) {
    return RemotePrediction(
      filename: json['filename'],
      classname: json['classname'],
      accuracy: json['accuracy'],
      timeStamp: json['uploadtime'],
    );
  }
}
