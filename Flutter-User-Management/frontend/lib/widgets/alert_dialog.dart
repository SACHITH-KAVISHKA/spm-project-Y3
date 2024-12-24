import 'package:flutter/material.dart';

void showAlertDialog(
    BuildContext context, String title, String content, {VoidCallback? onOkPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              if (onOkPressed != null) {
                onOkPressed();
              }
            },
          ),
        ],
      );
    },
  );
}
