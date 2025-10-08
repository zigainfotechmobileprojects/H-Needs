import 'package:hneeds_user/common/models/config_model.dart';
import 'package:hneeds_user/common/widgets/custom_image_widget.dart';
import 'package:hneeds_user/features/checkout/providers/checkout_provider.dart';
import 'package:hneeds_user/features/order/providers/order_provider.dart';
import 'package:hneeds_user/features/splash/providers/splash_provider.dart';
import 'package:hneeds_user/helper/price_converter_helper.dart';
import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/utill/dimensions.dart';
import 'package:hneeds_user/utill/images.dart';
import 'package:hneeds_user/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedPaymentWidget extends StatelessWidget {
  const SelectedPaymentWidget({
    super.key,
    required this.total,
  });

  final double total;

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final OrderProvider orderProvider = context.read<OrderProvider>();


    return  Container(
      decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.3), width: 1),
      ) : const BoxDecoration(),
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSizeDefault : 0,
      ),

      child: Column(children: [
        Row(children: [
          checkoutProvider.selectedPaymentMethod?.getWay == 'online'? CustomImageWidget(
            height: Dimensions.paddingSizeLarge,
            image: '${configModel.baseUrls?.getWayImageUrl}/${checkoutProvider.paymentMethod?.getWayImage}',
          ) : Image.asset(
            Images.cashOnDelivery,
            width: 20, height: 20, color: Theme.of(context).secondaryHeaderColor,
          ),

          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Text('${checkoutProvider.selectedPaymentMethod?.getWayTitle}',
            style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          )),

          Text(
            PriceConverterHelper.convertPrice(total), textDirection: TextDirection.ltr,
            style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
          )

        ]),
      ]),
    );
  }
}
