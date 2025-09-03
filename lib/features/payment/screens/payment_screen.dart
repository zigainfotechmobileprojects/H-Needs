import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:go_router/go_router.dart';
import 'package:hneeds_user/common/models/place_order_model.dart';
import 'package:hneeds_user/common/widgets/custom_alert_dialog_widget.dart';
import 'package:hneeds_user/features/checkout/widgets/order_cancel_dialog_widget.dart';
import 'package:hneeds_user/features/cart/providers/cart_provider.dart';
import 'package:hneeds_user/features/order/providers/order_provider.dart';
import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/localization/language_constrants.dart';
import 'package:hneeds_user/utill/app_constants.dart';
import 'package:hneeds_user/utill/routes.dart';
import 'package:hneeds_user/common/widgets/custom_loader_widget.dart';
import 'package:hneeds_user/helper/custom_snackbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final String? url;
  final int? orderId;
  const PaymentScreen({super.key, this.orderId, this.url});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;
  late MyInAppBrowser browser;
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url ?? '';
    _initData();
  }

  void _initData() async {
    //browser = MyInAppBrowser(context, orderId: widget.orderId);
    browser = MyInAppBrowser(context, _initData, orderId: widget.orderId);

    final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: false),
      webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true, isInspectable: kDebugMode),
    );

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri.uri(Uri.parse(selectedUrl))),
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        ResponsiveHelper.showDialogOrBottomSheet(
            context,
            CustomAlertDialogWidget(
              title: getTranslated('do_you_want_to_cancel_payment', context),
              leftButtonText: getTranslated('cancel', context),
              rightButtonText: getTranslated('proceed', context),
              icon: Icons.warning_amber,
              onPressLeft: () {
                // setState(() {
                //   canPop = true;
                // });
                Navigator.pop(context);
                context.pop();
                Future.delayed(const Duration(milliseconds: 500)).then((_) {
                  if (context.mounted) {
                    context.pop();
                  }
                });
              },
              onPressRight: () {
                context.pop();
                _initData();
                // _initData();
              },
            ));
      },
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              _isLoading
                  ? Center(
                      child: CustomLoaderWidget(
                          color: Theme.of(context).primaryColor),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _exitApp(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => OrderCancelDialogWidget(
              orderID: widget.orderId,
              fromCheckout: true,
            ));
  }
}

class MyInAppBrowser extends InAppBrowser {
  final int? orderId;
  final bool? fromCheckout;
  final BuildContext context;
  final Function callBack;
  MyInAppBrowser(this.context, this.callBack,
      {required this.orderId,
      super.windowId,
      super.initialUserScripts,
      this.fromCheckout});

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(
    url,
  ) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    ResponsiveHelper.showDialogOrBottomSheet(
        context,
        CustomAlertDialogWidget(
          title: getTranslated('do_you_want_to_cancel_payment', context),
          leftButtonText: getTranslated('cancel', context),
          rightButtonText: getTranslated('proceed', context),
          icon: Icons.warning_amber,
          onPressLeft: () {
            context.pop();
            Future.delayed(const Duration(milliseconds: 300)).then((_) {
              if (context.mounted) {
                context.pop();
              }
            });
          },
          onPressRight: () {
            log("------------------exit browser");
            context.pop();
            context.pop();
            callBack();
            // RouteHelper.getMainRoute(context,
            //     action: RouteAction.pushNamedAndRemoveUntil);
            // _pageRedirect(
            //     "${RouteHelper.orderSuccessScreen}/$orderId/payment-fail");
          },
        ));

    if (_canRedirect) {
      RouteHelper.getMainRoute(context,
          action: RouteAction.pushNamedAndRemoveUntil);
    }

    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
    // print("Started at: " + response.startTime.toString() + "ms ---> duration: " + response.duration.toString() + "ms " + (response.url ?? '').toString());
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) {
    if (_canRedirect) {
      bool checkedUrl = (url.contains(
          '${AppConstants.baseUrl}${RouteHelper.orderSuccessScreen}'));
      bool isSuccess = url.contains('success') && checkedUrl;
      bool isFailed = url.contains('fail') && checkedUrl;
      bool isCancel = url.contains('cancel') && checkedUrl;

      if (kDebugMode) {
        print(
            '----------------payment status -----$isCancel -- $isSuccess -- $isFailed');
        print('------------------url --- $url');
      }

      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }
      if (isSuccess) {
        String token = url
            .replaceRange(0, url.indexOf('token='), '')
            .replaceAll('token=', '');
        if (token.isNotEmpty) {
          final orderProvider =
              Provider.of<OrderProvider>(context, listen: false);
          String placeOrderString = utf8.decode(base64Url
              .decode(orderProvider.getPlaceOrderData()!.replaceAll(' ', '+')));

          String decodeValue =
              utf8.decode(base64Url.decode(token.replaceAll(' ', '+')));
          String paymentMethod =
              decodeValue.substring(0, decodeValue.indexOf('&&'));
          String transactionReference = decodeValue.substring(
              decodeValue.indexOf('&&') + '&&'.length, decodeValue.length);

          PlaceOrderModel? placeOrderBody =
              PlaceOrderModel.fromJson(jsonDecode(placeOrderString)).copyWith(
            paymentMethod: paymentMethod.replaceAll('payment_method=', ''),
            transactionReference: transactionReference
                .replaceRange(0,
                    transactionReference.indexOf('transaction_reference='), '')
                .replaceAll('transaction_reference=', ''),
          );

          Provider.of<OrderProvider>(context, listen: false)
              .placeOrder(context, placeOrderBody, _callback);
        } else {
          RouteHelper.getOrderSuccessScreen(context, '$orderId', 'payment-fail',
              action: RouteAction.pushReplacement);
        }
      } else if (isFailed) {
        RouteHelper.getOrderSuccessScreen(context, '', 'payment-fail',
            action: RouteAction.pushReplacement);
      } else if (isCancel) {
        RouteHelper.getOrderSuccessScreen(context, '', 'payment-cancel',
            action: RouteAction.pushReplacement);
      }
    }
  }

  void _callback(BuildContext context, bool isSuccess, String message,
      String orderID) async {
    Provider.of<CartProvider>(context, listen: false).clearCartList();

    if (isSuccess) {
      // Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessScreen}/$orderID/success');
      print("--------------(ID)---------$orderID");
      RouteHelper.getOrderSuccessScreen(context, orderID, 'success',
          action: RouteAction.pushReplacement);
    } else {
      showCustomSnackBar(message, context);
    }
  }
}
