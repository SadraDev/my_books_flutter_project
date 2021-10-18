import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  const Alert({
    Key? key,
    required this.title,
    required this.content,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final String? title;
  final String? content;
  final void Function()? onPressed;
  final String? child;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title!),
      content: Text(
        content!,
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(child!),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('ok'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
