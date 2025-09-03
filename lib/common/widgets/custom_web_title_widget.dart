import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/utill/dimensions.dart';
import 'package:hneeds_user/utill/styles.dart';
import 'package:flutter/material.dart';

class CustomWebTitleWidget extends StatelessWidget {
  final String title;
  const CustomWebTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Center(child: Text(title, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeOverLarge))),
    ) : const SizedBox();
  }
}
