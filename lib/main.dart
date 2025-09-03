import 'dart:async';
import 'dart:io';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hneeds_user/common/models/notification_body.dart';
import 'package:hneeds_user/common/widgets/cookies_widget.dart';
import 'package:hneeds_user/features/address/providers/location_provider.dart';
import 'package:hneeds_user/features/auth/providers/registration_provider.dart';
import 'package:hneeds_user/features/auth/providers/verification_provider.dart';
import 'package:hneeds_user/features/checkout/providers/checkout_provider.dart';
import 'package:hneeds_user/features/rate_review/providers/rate_review_provider.dart';
import 'package:hneeds_user/features/track/providers/order_map_provider.dart';
import 'package:hneeds_user/helper/notification_helper.dart';
import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/features/flash_sale/providers/flash_sale_provider.dart';
import 'package:hneeds_user/utill/routes.dart';
import 'package:hneeds_user/common/widgets/third_party_chat_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hneeds_user/localization/app_localization.dart';
import 'package:hneeds_user/features/auth/providers/auth_provider.dart';
import 'package:hneeds_user/features/home/providers/banner_provider.dart';
import 'package:hneeds_user/features/cart/providers/cart_provider.dart';
import 'package:hneeds_user/features/category/providers/category_provider.dart';
import 'package:hneeds_user/features/chat/providers/chat_provider.dart';
import 'package:hneeds_user/features/coupon/providers/coupon_provider.dart';
import 'package:hneeds_user/provider/localization_provider.dart';
import 'package:hneeds_user/features/notification/providers/notification_provider.dart';
import 'package:hneeds_user/features/order/providers/order_provider.dart';
import 'package:hneeds_user/features/address/providers/address_provider.dart';
import 'package:hneeds_user/features/product/providers/product_provider.dart';
import 'package:hneeds_user/provider/language_provider.dart';
import 'package:hneeds_user/features/onboarding/providers/onboarding_provider.dart';
import 'package:hneeds_user/features/profile/providers/profile_provider.dart';
import 'package:hneeds_user/features/search/providers/search_provider.dart';
import 'package:hneeds_user/features/splash/providers/splash_provider.dart';
import 'package:hneeds_user/provider/theme_provider.dart';
import 'package:hneeds_user/features/wishlist/providers/wishlist_provider.dart';
import 'package:hneeds_user/theme/dark_theme.dart';
import 'package:hneeds_user/theme/light_theme.dart';
import 'package:hneeds_user/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher, kIsWeb;
import 'package:url_strategy/url_strategy.dart';
import 'di_container.dart' as di;
import 'provider/news_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  if(ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();


  if(kIsWeb) {
    await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyBCtDfdfPqxXDO6rDNlmQC1VJSH3w",
      authDomain: "gem-b5006.firebaseapp.com",
      projectId: "gem-b5006",
      storageBucket: "gem-b5006.appspot.com",
      messagingSenderId: "384321080318",
      appId: "1:384321080318:web:9cf2ec90f41dfb8a2c0eaf",
      measurementId: "G-RQ899NQVHN",
    ));

    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "YOUR_APP_ID",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );

  }else{
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission();



  }
  await di.init();
  try {
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }catch(e) {
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<RegistrationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<VerificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AddressProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderMapProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CheckoutProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NewsLetterProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FlashSaleProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<RateReviewProvider>()),
    ],
    child: const MyApp( isWeb: !kIsWeb),
  ));
}

class MyApp extends StatefulWidget {
  final NotificationBody? body;
  final bool isWeb;
  const MyApp({super.key, this.body, required this.isWeb});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Provider.of<SplashProvider>(context, listen: false).initSharedData();

    if(kIsWeb) {
      Provider.of<CartProvider>(context, listen: false).getCartData();
      Provider.of<SplashProvider>(context, listen: false).getPolicyPage();
      Provider.of<SplashProvider>(context, listen: false).getDeliveryInfo();
      _route();
    }

  }
  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig().then((bool isSuccess) async {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          print("-----HERE I AM-----");
          Provider.of<AuthProvider>(context, listen: false).updateToken();
        });
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child){
        return (kIsWeb && splashProvider.configModel == null) ? const SizedBox() : MaterialApp.router(
          //routerConfig: RouteHelper.goRoutes,
          routerDelegate: RouteHelper.goRoutes.routerDelegate,
          routeInformationParser: RouteHelper.goRoutes.routeInformationParser,
          routeInformationProvider: RouteHelper.goRoutes.routeInformationProvider,
          title: splashProvider.configModel != null ? splashProvider.configModel!.ecommerceName ?? '' : AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
          locale: Provider.of<LocalizationProvider>(context).locale,
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: locals,
          scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
            PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown
          }),
          builder: (context, widget)=> MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
            child: Material(child: Stack(children: [
              widget!,

              if(ResponsiveHelper.isDesktop(context))  const Positioned.fill(
                child: Align(alignment: Alignment.bottomRight, child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  child: ThirdPartyChatWidget(),
                )),
              ),

              if(kIsWeb && splashProvider.configModel!.cookiesManagement != null &&
                  splashProvider.configModel!.cookiesManagement!.status!
                  && !splashProvider.getAcceptCookiesStatus(splashProvider.configModel!.cookiesManagement!.content)
                  && splashProvider.cookiesShow)
                const Positioned.fill(child: Align(alignment: Alignment.bottomCenter, child: CookiesWidget())),

            ])),
          ),
        );
      },

    );
  }
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}