import 'package:flutter/material.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();

    addData();
  }

  addData() async {
    UserProvider _userprovider = Provider.of(context, listen: false);

    await _userprovider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    // Create layout that corresponds to each screen
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          // Display web screen
          return widget.webScreenLayout;
        } else {
          // Display mobile screen
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}
