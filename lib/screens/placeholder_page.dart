import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  final String owner;

  const PlaceholderPage({super.key, required this.title, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Modul $title\nsedang dikerjakan $owner', textAlign: TextAlign.center));
  }
}
