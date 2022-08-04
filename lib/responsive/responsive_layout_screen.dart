import 'package:flutter/material.dart';
import 'package:instagramclone/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create layout that corresponds to each screen
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          // Display web screen
          return webScreenLayout;
        } else {
          // Display mobile screen
          return mobileScreenLayout;
        }
      },
    );
  }
}
