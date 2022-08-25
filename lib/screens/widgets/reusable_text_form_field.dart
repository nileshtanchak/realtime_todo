import 'package:flutter/material.dart';

class ReusableTextFormField extends StatelessWidget {
  const ReusableTextFormField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyBordType,
    this.checkValidation,
  });

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputType? keyBordType;
  final String? Function(String?)? checkValidation;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 3,
      minLines: 1,
      keyboardType: keyBordType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: checkValidation,
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
