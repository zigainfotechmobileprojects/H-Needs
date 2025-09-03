import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:hneeds_user/utill/styles.dart';

void showCustomSnackBar(String? message, BuildContext context,
    {bool isError = true, Duration? duration}) {
  final width = MediaQuery.of(context).size.width;
  ResponsiveHelper.isDesktop(context)
      ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(message!, style: rubikRegular.copyWith(color: Colors.white)),
          margin: ResponsiveHelper.isDesktop(context)
              ? EdgeInsets.only(
                  right: width * 0.75,
                  bottom: Dimensions.paddingSizeLarge,
                  left: Dimensions.paddingSizeExtraSmall)
              : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.up,
          duration: duration ??
              Duration(seconds: ResponsiveHelper.isDesktop(context) ? 5 : 2),
          backgroundColor: isError ? Colors.red : Colors.green))
      : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          content:
              Text(message!, style: rubikRegular.copyWith(color: Colors.white)),
          duration: duration ?? const Duration(seconds: 2),
        ));
}
