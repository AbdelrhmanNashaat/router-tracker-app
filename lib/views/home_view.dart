import 'package:flutter/material.dart';

import 'widgets/google_map_widget.dart';
import 'widgets/text_filed.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMapView(),
            Positioned(
              bottom: 16,
              right: 16,
              child: CustomTextFiledWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
