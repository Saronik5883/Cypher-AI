import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  Color? headerColor;
  final String headerText;
  final String descriptionText;
  FeatureBox({Key? key, required this.color,required this.headerText, required this.descriptionText, this.headerColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: TextStyle(
                fontFamily: 'Cera Pro',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                  color: headerColor,
              ),
              ),
            ),
            const SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                descriptionText,
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
