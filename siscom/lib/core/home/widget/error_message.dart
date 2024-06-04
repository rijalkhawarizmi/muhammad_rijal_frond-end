

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return 
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 20,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Please enter a valid amount',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            );
  }
}