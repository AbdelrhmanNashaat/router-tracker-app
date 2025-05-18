import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  final TextEditingController searchController;
  const CustomTextFiled({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search here',
        prefixIcon: const Icon(Icons.search),
        border: textFiledBorder(),
        enabledBorder: textFiledBorder(),
        focusedBorder: textFiledBorder(),
      ),
    );
  }

  OutlineInputBorder textFiledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    );
  }
}
