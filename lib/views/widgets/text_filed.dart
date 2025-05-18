import 'package:flutter/material.dart';

class CustomTextFiledWidget extends StatelessWidget {
  const CustomTextFiledWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Search here..',
        border: borderMethod(),
        enabledBorder: borderMethod(),
        focusedBorder: borderMethod(),
      ),
    );
  }

  OutlineInputBorder borderMethod() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(24),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }
}
