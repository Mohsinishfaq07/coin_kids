import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String titleText; // Required title for the field
  final String hintText; // Placeholder for the text field
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final IconData? prefixIcon; // Optional prefix icon
  final VoidCallback? onPrefixTap; // Optional callback for prefix icon tap
  final IconData? suffixIcon; // Optional suffix icon
  final VoidCallback? onSuffixTap; // Optional callback for suffix icon tap
  final bool
      obscureText; // Whether the text should be obscured (e.g., password)
  final TextInputType keyboardType; // Input type for the keyboard
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.titleText, // Title for the field is now required
    required this.hintText,
    this.prefixIcon,
    this.onPrefixTap,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align title text to the left
      children: [
        Text(
          titleText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color.fromARGB(255, 9, 90, 156), // Title color
          ),
        ),
        const SizedBox(height: 8), // Spacing between title and text field
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white38, // Background color for the text field
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey), // Hint text color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey, // Border color when unfocused
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey, // Border color when enabled
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.blue, // Border color when focused
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            prefixIcon: prefixIcon != null
                ? GestureDetector(
                    onTap: onPrefixTap,
                    child: Icon(prefixIcon, color: Colors.grey),
                  )
                : null, // Show prefix icon if provided
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, color: Colors.grey),
                  )
                : null, // Show suffix icon if provided
          ),
          style: const TextStyle(color: Colors.black), // Input text color
        ),
      ],
    );
  }
}
