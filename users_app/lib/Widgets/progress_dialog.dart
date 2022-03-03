import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  String? Message;

  ProgressDialog({this.Message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const SizedBox(
                width: 6,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(
                width: 26,
              ),
              Text(
                Message!,
                style: const TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
