import 'package:flutter/material.dart';
import 'package:tvst/consts/consts_shelf.dart';

class TextInputField extends StatelessWidget {
  final IconData iconData;
  final String label;
  final TextEditingController textEditingController;
  final bool isObs;
  const TextInputField({
    Key? key,
    required this.iconData,
    required this.label,
    required this.textEditingController,
    this.isObs = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(iconData),
        labelStyle: const TextStyle(
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      obscureText: isObs,
    );
  }
}
