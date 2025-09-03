import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hneeds_user/common/enums/footer_type_enum.dart';
import 'package:hneeds_user/common/widgets/custom_app_bar_widget.dart';
import 'package:hneeds_user/common/widgets/custom_button_widget.dart';
import 'package:hneeds_user/common/widgets/custom_loader_widget.dart';
import 'package:hneeds_user/common/widgets/custom_text_field_widget.dart';
import 'package:hneeds_user/common/widgets/footer_web_widget.dart';
import 'package:hneeds_user/common/widgets/phone_number_field_widget.dart';
import 'package:hneeds_user/common/widgets/web_app_bar_widget.dart';
import 'package:hneeds_user/features/order/providers/order_provider.dart';
import 'package:hneeds_user/features/order/widgets/track_order_web_widget.dart';
import 'package:hneeds_user/features/splash/providers/splash_provider.dart';
import 'package:hneeds_user/helper/custom_snackbar_helper.dart';
import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/localization/language_constrants.dart';
import 'package:hneeds_user/utill/dimensions.dart';
import 'package:hneeds_user/utill/images.dart';
import 'package:hneeds_user/utill/routes.dart';
import 'package:hneeds_user/utill/styles.dart';
import 'package:provider/provider.dart';

class OrderSearchScreen extends StatefulWidget {
  const OrderSearchScreen({super.key});

  @override
  State<OrderSearchScreen> createState() => _OrderSearchScreenState();
}

class _OrderSearchScreenState extends State<OrderSearchScreen> {
  final TextEditingController orderIdTextController = TextEditingController();
  final TextEditingController phoneNumberTextController = TextEditingController();
  final FocusNode orderIdFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  String? countryCode;

  @override
  void initState() {
    countryCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.countryCode!).code;
    Provider.of<OrderProvider>(context, listen: false).clearPrevData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(
        preferredSize: Size.fromHeight(100), child: WebAppBarWidget(),
      ) : CustomAppBarWidget(
        isBackButtonExist: ResponsiveHelper.isMobile(context),
        title: getTranslated('order_details', context),
        actionView: _TrackRefreshButtonView(
          orderIdTextController: orderIdTextController,
          phoneNumberTextController: phoneNumberTextController,
        ),
      ) as PreferredSizeWidget,

      body: CustomScrollView(slivers: [

        SliverToBoxAdapter(child: Container(
          margin: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(horizontal: (MediaQuery.sizeOf(context).width - Dimensions.webScreenWidth) / 2).copyWith(top: Dimensions.paddingSizeDefault) : null,
          decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
            color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
            boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
          ) : null,
          child: Column(children: [
            if(ResponsiveHelper.isDesktop(context)) Center(child: Container(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              width: Dimensions.webScreenWidth,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                const SizedBox(width: 150,),
                Text(getTranslated('track_your_order', context), style: rubikBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: _TrackRefreshButtonView(
                    orderIdTextController: orderIdTextController,
                    phoneNumberTextController: phoneNumberTextController,
                  ),
                ),
              ]),
            )),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column(children: [

                Padding(
                  padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall,
                  ) : const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: _InputView(
                    orderIdTextController: orderIdTextController, orderIdFocusNode: orderIdFocusNode,
                    phoneFocusNode: phoneFocusNode, phoneNumberTextController: phoneNumberTextController,
                    onValueChange: (String code) {
                      setState(() {
                        countryCode = code;
                      });
                    },
                    countryCode: countryCode,

                  ),
                ),

               Consumer<OrderProvider>(builder: (context, orderProvider, _) {
                    return orderProvider.trackModel == null || orderProvider.trackModel?.id == null  ? Column(children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Image.asset(Images.outForDelivery, color: Theme.of(context).disabledColor.withOpacity(0.5), width:  70),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text(getTranslated('enter_your_order_id', context), style: rubikRegular.copyWith(
                        color: Theme.of(context).disabledColor,
                      ), maxLines: 2,  textAlign: TextAlign.center),
                      const SizedBox(height: 100),
                    ]) : ResponsiveHelper.isDesktop(context) ? TrackOrderWebWidget(
                      phoneNumber: '${CountryCode.fromCountryCode(countryCode!).dialCode}${phoneNumberTextController.text.trim()}',
                    ) : const SizedBox();
                }),


              ]),
            ),

          ]),
        )),

        const FooterWebWidget(footerType: FooterType.sliver),
      ]),
    );
  }
}


class _TrackRefreshButtonView extends StatelessWidget {
  const _TrackRefreshButtonView({
    super.key,
    required this.orderIdTextController,
    required this.phoneNumberTextController,
  });

  final TextEditingController orderIdTextController;
  final TextEditingController phoneNumberTextController;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 0,
      hoverElevation: 0,
      hoverColor:  Theme.of(context).primaryColor.withOpacity(0.1),
      backgroundColor:  Theme.of(context).cardColor,
      onPressed: () {
        orderIdTextController.clear();
        phoneNumberTextController.clear();
        Provider.of<OrderProvider>(context, listen: false).clearPrevData(isUpdate: true);
      },
      label: Text(getTranslated('refresh', context), style: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
      icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
    );
  }
}


class _InputView extends StatelessWidget {
  const _InputView({
    super.key,
    required this.orderIdTextController,
    required this.orderIdFocusNode,
    required this.phoneFocusNode,
    required this.phoneNumberTextController,
    required this.countryCode,
    required this.onValueChange,
  });

  final TextEditingController orderIdTextController;
  final FocusNode orderIdFocusNode;
  final FocusNode phoneFocusNode;
  final TextEditingController phoneNumberTextController;
  final String? countryCode;
  final Function(String value) onValueChange;

  @override
  Widget build(BuildContext context) {

    return !ResponsiveHelper.isDesktop(context) ? Column(children: [
      FormField(builder: (builder)=> Column(children: [
        _OrderIdTextField(
          orderIdTextController: orderIdTextController,
          orderIdFocusNode: orderIdFocusNode,
          phoneFocusNode: phoneFocusNode,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        PhoneNumberFieldWidget(
          onValueChange: onValueChange,
          countryCode: countryCode,
          phoneNumberTextController: phoneNumberTextController,
          phoneFocusNode: phoneFocusNode,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

      ])),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      TrackOrderButtonView(
        orderIdTextController: orderIdTextController,
        countryCode: countryCode,
        phoneNumberTextController: phoneNumberTextController,
      ),
    ]) : Center(child: SizedBox(
      width: Dimensions.webScreenWidth,
      child: FormField(builder: (builder)=> Row(children: [
        Expanded(child: _OrderIdTextField(
          orderIdTextController: orderIdTextController,
          orderIdFocusNode: orderIdFocusNode,
          phoneFocusNode: phoneFocusNode,
        )),
        const SizedBox(width: Dimensions.paddingSizeLarge),

        Expanded(child: PhoneNumberFieldWidget(
          onValueChange: onValueChange, countryCode: countryCode,
          phoneNumberTextController: phoneNumberTextController,
          phoneFocusNode: phoneFocusNode,
        )),
        const SizedBox(width: Dimensions.paddingSizeLarge),


        SizedBox(
          width: 200,
          child: TrackOrderButtonView(
            orderIdTextController: orderIdTextController,
            countryCode: countryCode,
            phoneNumberTextController: phoneNumberTextController,
          ),
        ),
      ])),
    ));
  }
}

class TrackOrderButtonView extends StatelessWidget {
  const TrackOrderButtonView({
    super.key,
    required this.orderIdTextController,
    required this.countryCode,
    required this.phoneNumberTextController,
  });

  final TextEditingController orderIdTextController;
  final String? countryCode;
  final TextEditingController phoneNumberTextController;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        return orderProvider.isLoading ? CustomLoaderWidget(color: Theme.of(context).primaryColor) : CustomButtonWidget(
          radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSizeDefault : Dimensions.radiusSizeFifty,
          btnTxt: getTranslated('search_order', context),
          onTap: (){
            final String orderId = orderIdTextController.text.trim();
            final dialCode = CountryCode.fromCountryCode(countryCode!).dialCode;

            final String phoneNumber = '$dialCode${phoneNumberTextController.text.trim()}';

            if(orderId.isEmpty){
              showCustomSnackBar(getTranslated('enter_order_id', context), context);
            }else if(phoneNumberTextController.text.trim().isEmpty){
              showCustomSnackBar(getTranslated('enter_phone_number', context), context);
            }else{
              if(ResponsiveHelper.isDesktop(context)){
                orderProvider.trackOrder(orderId, null, context, true, phoneNumber: phoneNumber);
              }else{
                context.go(RouteHelper.getOrderTrackingRoute(context, int.parse(orderId), phoneNumber));
              }
            }

          },
        );
      }
    );
  }
}



class _OrderIdTextField extends StatelessWidget {
  const _OrderIdTextField({
    super.key,
    required this.orderIdTextController,
    required this.orderIdFocusNode,
    required this.phoneFocusNode,
  });

  final TextEditingController orderIdTextController;
  final FocusNode orderIdFocusNode;
  final FocusNode phoneFocusNode;

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldWidget(
      controller: orderIdTextController,
      focusNode: orderIdFocusNode,
      nextFocus: phoneFocusNode,
      isShowBorder: true,
      hintText: getTranslated('order_id', context),
      prefixAssetUrl: Images.order,
      isShowPrefixIcon: true,
      suffixAssetUrl: Images.order,
      inputType: TextInputType.phone,
      contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: 20),

    );
  }
}