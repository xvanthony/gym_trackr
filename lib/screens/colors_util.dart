// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}


class EmoticonFace extends StatelessWidget {
  final String emoticonFace;

  const EmoticonFace({
    Key? key,
    required this.emoticonFace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 30, 136, 229),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            emoticonFace,
            style: TextStyle(
              fontSize: 28,
            ),
          )
        ),
    );
  }
}

class ExerciseTile extends StatelessWidget {

  final icon;
  final String exerciseName;
  final String exerciseGroup;

  const ExerciseTile({
    Key? key,
    required this.icon,
    required this.exerciseName,
    required this.exerciseGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
                      color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                            children: [
                              Icon(icon),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //title
                                Text(exerciseName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                //subtitle
                                Text(exerciseGroup,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 14,
                                  )
                                ),
                              ],
                            ),
                            ],
                            ),
                            Icon(Icons.more_horiz),
                            ],
                          ),
                        ),
    );
  }
}
