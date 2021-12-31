import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    'Enostavna aplikacija za prikaz vremena.',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Erik Pahor 2021',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
              Text(
                'Vir podatkov: ARSO',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
