import 'package:flutter/material.dart';

void noImageError(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Error'),
      content: Text('No Image Selected!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: Text('OK'),
        )
      ],
    ),
  );
}
