import 'package:flutter/material.dart';
import 'package:tmx_player/widgets/colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.textController,
    required this.validator,
    this.onChanged,
  });
  final String hintText;
  final IconData icon;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        validator: validator,
        controller: textController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: emptyColors,
            size: 25,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: emptyColors),
          filled: true,
          fillColor: Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 0, color: navIconsC),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 0, color: Color(0xFF153950)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 1,
              color: emptyColors,
            ),
          ),
        ),
      ),
    );
  }
}
