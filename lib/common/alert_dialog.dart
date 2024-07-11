import 'package:flutter/material.dart';

class AlertDialogs {
  static void show(
    BuildContext context,
    String title,
    String message, {
    String buttonText = "OK",
    Function()? onTap,
    Function()? onCancelTap,
    bool showCancelButton = false,
  }) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: message.isEmpty ? null : Text(message),
      actions: [
        if (showCancelButton)
          TextButton(
            onPressed: onCancelTap,
            child: const Text('Cancel'),
          ),
        TextButton(
          onPressed: onTap,
          child: Text(buttonText),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showDeleteAccount(
    BuildContext context,
    String title,
    String message, {
    Function()? onDeleteButtonTap,
    Function()? onNoTap,
  }) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onDeleteButtonTap,
          child: const Text(
            'Delete Forever',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        TextButton(
          onPressed: onNoTap,
          child: const Text('No'),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
