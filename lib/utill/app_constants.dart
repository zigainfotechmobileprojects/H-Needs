import 'package:hneeds_user/common/models/language_model.dart';
import 'package:hneeds_user/common/enums/app_mode.dart';
import 'package:hneeds_user/utill/images.dart';

class AppConstants {
  static const String appName = 'H-NEEDS';
  static const double appVersion = 7.4;
  static const AppMode appMode = AppMode.release;
  static const String fontFamily = 'Exo';
  static const String baseUrl = 'https://admin.hneeds.net';
  static const String categoryUri = '/api/v1/categories';
  static const String bannerUri = '/api/v1/banners';
  static const String latestProductUri = '/api/v1/products/latest';
  static const String searchProductUri = '/api/v1/products/details/';
  static const String subCategoryUri = '/api/v1/categories/childes/';
  static const String categoryProductUri = '/api/v1/categories/products/';
  static const String configUri = '/api/v1/config';
  static const String trackUri = '/api/v1/customer/order/track';
  static const String messageUri = '/api/v1/customer/message/get';
  static const String sendMessageUri = '/api/v1/customer/message/send';
  static const String forgetPasswordUri = '/api/v1/auth/forgot-password';
  static const String verifyTokenUri = '/api/v1/auth/verify-token';
  static const String verifyOtpUri = '/api/v1/auth/verify-otp';
  static const String resetPasswordUri = '/api/v1/auth/reset-password';
  static const String checkPhoneUri = '/api/v1/auth/check-phone';
  static const String verifyPhoneUri = '/api/v1/auth/verify-phone';
  static const String checkEmailUri = '/api/v1/auth/check-email';
  static const String verifyEmailUri = '/api/v1/auth/verify-email';
  static const String registerUri = '/api/v1/auth/registration';
  static const String loginUri = '/api/v1/auth/login';
  static const String tokenUri = '/api/v1/customer/cm-firebase-token';
  static const String placeOrderUri = '/api/v1/customer/order/place';
  static const String addressListUri = '/api/v1/customer/address/list';
  static const String removeAddressUri =
      '/api/v1/customer/address/delete?address_id=';
  static const String addAddressUri = '/api/v1/customer/address/add';
  static const String updateAddressUri = '/api/v1/customer/address/update/';
  static const String offerProductUri = '/api/v1/products/discounted';
  static const String customerInfoUri = '/api/v1/customer/info';
  static const String couponUri = '/api/v1/coupon/list';
  static const String couponApplyUri = '/api/v1/coupon/apply?code=';
  static const String orderListUri = '/api/v1/customer/order/list';
  static const String orderCancelUri = '/api/v1/customer/order/cancel';
  static const String orderDetailsUri = '/api/v1/customer/order/details';
  static const String wishListGetUri = '/api/v1/customer/wish-list';
  static const String addWishListUri = '/api/v1/customer/wish-list/add';
  static const String removeWishListUri = '/api/v1/customer/wish-list/remove';
  static const String notificationUri = '/api/v1/notifications';
  static const String updateProfileUri = '/api/v1/customer/update-profile';
  static const String searchUri = '/api/v1/products/search';
  static const String reviewUri = '/api/v1/products/reviews/submit';
  static const String productDetailsUri = '/api/v1/products/details/';
  static const String lastLocationUri =
      '/api/v1/delivery-man/last-location?order_id=';
  static const String deliverManReviewUri =
      '/api/v1/delivery-man/reviews/submit';
  static const String productReviewUri = '/api/v1/products/reviews/';
  static const String distanceMatrixUri = '/api/v1/mapapi/distance-api';
  static const String searchLocationUri =
      '/api/v1/mapapi/place-api-autocomplete';
  static const String placeDetailsUri = '/api/v1/mapapi/place-api-details';
  static const String geocodeUri = '/api/v1/mapapi/geocode-api';
  static const String emailSubscribeUri = '/api/v1/subscribe-newsletter';
  static const String customerRemove = '/api/v1/customer/remove-account';
  static const String policyPage = '/api/v1/pages';
  static const String subscribeToTopic = '/api/v1/fcm-subscribe-to-topic';
  static const String socialLogin = '/api/v1/auth/social-customer-login';
  static const String flashSale = '/api/v1/flash-sale';
  static const String newArrivalProducts = '/api/v1/products/new-arrival';
  static const String featureCategory = '/api/v1/categories/featured';
  static const String reorderProductList = '/api/v1/customer/reorder/products';
  static const String registerWithOtp = '/api/v1/auth/registration-with-otp';
  static const String registerWithSocialMedia =
      '/api/v1/auth/registration-with-social-media';
  static const String verifyProfileInfo =
      '/api/v1/customer/verify-profile-info';
  static const String getDeliveryInfo = '/api/v1/config/delivery-fee';
  static const String firebaseAuthVerify = '/api/v1/auth/firebase-auth-verify';
  static const String getLocationDataUri = '/api/v1/get-city';

  //MESSAGING
  static const String getDeliverymanMessageUri =
      '/api/v1/customer/message/get-order-message';
  static const String getAdminMessageUrl =
      '/api/v1/customer/message/get-admin-message';
  static const String sendMessageToAdminUrl =
      '/api/v1/customer/message/send-admin-message';
  static const String sendMessageToDeliveryManUrl =
      '/api/v1/customer/message/send/customer';
  static const String addGuest = '/api/v1/guest/add';
  static const String existingAccountCheck =
      '/api/v1/auth/existing-account-check';

  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userAddress = 'user_address';
  static const String searchAddress = 'search_address';
  static const String userLogData = 'user_log_data';
  static const String topic = 'market';
  static const String onBoardingSkip = 'on_boarding_skip';
  static const String langSkip = 'lang_skip';
  static const String userId = 'user_id';
  static const String cookingManagement = 'cookies_management';
  static const String placeOrderData = 'place_order_data';
  static const String guestId = 'guest_id';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.unitedKingdom,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.arabic,
        languageName: 'Arabic',
        countryCode: 'SA',
        languageCode: 'ar'),
  ];
}
