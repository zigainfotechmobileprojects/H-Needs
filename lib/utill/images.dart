import 'package:hneeds_user/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Images {
  static const String home = 'assets/image/home_icon.webp';
  static const String maintenance = 'assets/image/maintenance.webp';
  static const String more = 'assets/image/more_icon.webp';
  static const String fav = 'assets/image/fav_icon.webp';
  static const String cart = 'assets/image/cart_icon.webp';
  static const String filter = 'assets/image/filter_icon.webp';
  static const String coupon = 'assets/image/coupon.webp';
  // static const String language = 'assets/image/language.webp';
  static const String logOut = 'assets/image/log_out.webp';
  // static const String message = 'assets/image/message.webp';
  // static const String order = 'assets/image/order.webp';
  static const String payment = 'assets/image/payment.webp';
  static const String profile = 'assets/image/profile.webp';
  static const String image = 'assets/image/image.webp';
  static const String send = 'assets/image/send.webp';
  static const String line = 'assets/image/line.webp';
  static const String couponBg = 'assets/image/coupon_bg.webp';
  static const String percentage = 'assets/image/percentage.webp';
  static const String noDataImage = 'assets/image/no_data_image.webp';
  static const String noOrderImage = 'assets/image/no_order_image.webp';
  static const String shoppingCart = 'assets/image/shopping_cart.webp';
  // static const String support = 'assets/image/support.webp';
  static const String deliveryBoyMarker =
      'assets/image/delivery_boy_marker.webp';
  static const String destinationMarker =
      'assets/image/destination_marker.webp';
  static const String restaurantMarker = 'assets/image/restaurant_marker.webp';
  static const String unselectedRestaurantMarker =
      'assets/image/unselected_restaurant_marker.webp';
  static const String wallet = 'assets/image/wallet.webp';
  static const String guestLogin = 'assets/image/guest_login.webp';
  static const String placeholderLight = 'assets/image/placeholder.webp';
  static const String placeholderDark = 'assets/image/dark_placeholder.webp';
  static const String placeHolderOneToOne =
      'assets/image/place_holder_one_one.webp';
  static String placeholder(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? placeholderDark
        : placeholderLight;
  }

  static const String logo = 'assets/image/logo.webp';
  static const String login = 'assets/icon/login.webp';
  // static const String helpSupport = 'assets/icon/help_support.webp';
  // static const String privacyPolicy = 'assets/icon/privacy_policy.webp';
  // static const String termsAndCondition = 'assets/icon/terms_and_condition.webp';
  // static const String aboutUs = 'assets/icon/about_us.webp';
  // static const String address = 'assets/image/location.webp';
  static const String notificationWeb = 'assets/image/notification.webp';
  static const String version = 'assets/icon/version.webp';
  static const String update = 'assets/image/update.webp';
  static const String loginImage = 'assets/image/login_image.webp';
  // static const String returnPolicy = 'assets/image/return_policy.webp';
  // static const String cancellationPolicy = 'assets/image/cancellation_policy.webp';
  // static const String refundPolicy = 'assets/image/refound_policy.webp';
  static const String google = 'assets/image/google.webp';
  static const String facebook = 'assets/image/facebook.webp';
  static const String facebookSocial = 'assets/image/facebook_social.webp';
  static const String flashSale = 'assets/image/flash_sale.webp';
  static const String offerProductBg = 'assets/image/offer_product_bg.webp';
  static const String deliveryAddressIcon =
      'assets/image/delivery_address_icon.webp';
  static const String wishListNoData = 'assets/image/wishlist_nodata.webp';
  static const String percent = 'assets/image/percent.webp';
  static const String amount = 'assets/image/amount.webp';
  // static const String profileMenuIcon = 'assets/image/profile_menu_icon.webp';
  // static const String couponMenuIcon = 'assets/image/coupon_menu_icon.webp';

  // for Icon
  static const String marker = 'assets/icon/marker.webp';
  static const String myLocation = 'assets/icon/my_location.webp';
  static const String search = 'assets/icon/search.webp';
  static const String edit = 'assets/svg/edit.svg';
  static const String homeIcon = 'assets/icon/home.webp';
  static const String menu = 'assets/icon/menu.webp';
  static const String workplace = 'assets/icon/workplace.webp';
  static const String map = 'assets/icon/map.webp';
  static const String notification = 'assets/icon/notification.webp';
  static const String closeLock = 'assets/icon/close_lock.webp';
  static const String emailWithBackground =
      'assets/icon/email_with_background.webp';
  static const String openLock = 'assets/icon/open_lock.webp';
  static const String doneWithFullBackground =
      'assets/icon/done_with_full_background.webp';
  static const String filterIcon = 'assets/icon/filter_icon.webp';
  static const String location = 'assets/icon/location.webp';
  // static const String couponIcon = 'assets/icon/coupon_icon.webp';
  // static const String userDeleteIcon = 'assets/icon/user_delete_icon.webp';

  static const String whatsapp = 'assets/icon/whatsapp.webp';
  static const String telegram = 'assets/icon/telegram.webp';
  static const String messenger = 'assets/icon/messenger.webp';
  static const String ratingIcon = 'assets/icon/rating_icon.webp';

  // for Image
  static const String arabic = 'assets/image/arabic.webp';
  static const String china = 'assets/image/china.webp';
  static const String germany = 'assets/image/germany.webp';
  static const String italy = 'assets/image/italy.webp';
  static const String japan = 'assets/image/japan.webp';
  static const String korea = 'assets/image/korean.webp';
  static const String onBoardingOne = 'assets/image/onboarding_one.webp';
  static const String onBoardingThree = 'assets/image/onboarding_three.webp';
  static const String onBoardingTwo = 'assets/image/onboarding_two.webp';
  static const String unitedKingdom = 'assets/image/united_kindom.webp';
  static const String done = 'assets/icon/done.webp';

  static const String close = 'assets/image/clear.webp';
  static const String shoppingCartBold = 'assets/image/cart_bold.webp';
  static const String twitter = 'assets/image/twitter.webp';
  static const String youtube = 'assets/image/youtube.webp';
  static const String playStore = 'assets/image/play_store.webp';
  static const String appStore = 'assets/image/app_store.webp';
  static const String linkedin = 'assets/image/linkedin.webp';
  static const String instagram = 'assets/image/instagram.webp';
  static const String pinterest = 'assets/image/pinterest.webp';
  static const String locationBannerImage =
      'assets/image/location_banner_image.webp';
  static const String cashOnDelivery = 'assets/image/cash_on_delivery.webp';
  static const String orderDelivered = 'assets/image/order_delivered.webp';
  static const String orderPlace = 'assets/image/order_place.webp';
  static const String wareHouse = 'assets/image/ware_house.webp';
  static const String outForDelivery = 'assets/image/out_for_delivery.webp';
  static const String preparingItems = 'assets/image/preparing_items.webp';
  static const String orderAccepted = 'assets/image/order_accepted.webp';
  static const String order = 'assets/image/order.webp';
  static const String emailVerificationBackgroundIcon =
      'assets/image/email_verification_background.webp';
  static const String phoneVerificationBackgroundIcon =
      'assets/image/phone_verification_background.webp';
  static const String referralIcon = 'assets/image/referral_icon.webp';
  static const String userIcon = 'assets/image/user.webp';
  static const String notVerifiedProfileIcon = 'assets/image/not_verified.webp';
  static const String verifiedProfileIcon = 'assets/image/verified.webp';
  static const String noMapBackground = 'assets/image/no_map_background.webp';
  static const String forgotPasswordBackground =
      'assets/image/forgot_password_background.webp';
  static const String forgotVerificationBackground =
      'assets/image/forgot_verification_background.webp';
  static const String changePasswordBackground =
      'assets/image/change_password_background.webp';
  static const String emailPhoneIcon = 'assets/image/email_phone_icon.webp';

  static const String mapIcon = 'assets/image/map_icon.webp';
  static const String workPlaceIcon = 'assets/image/workplace_icon.webp';

  static const String email = 'assets/image/email.webp';
  static const String password = 'assets/image/password.webp';
  static const String appleLogo = 'assets/image/apple_logo.webp';

  static String getSocialImage(String name) => 'assets/image/$name.webp';

  ///this is [svg] section don't put other extension

  static const String support = 'assets/svg/support.svg';
  static const String couponBackground = 'assets/svg/coupon_background.svg';
  static const String branchIcon = 'assets/svg/branch_icon.svg';
  static const String callIcon = 'assets/svg/call_icon.svg';
  static const String messageIcon = 'assets/svg/message_icon.svg';
  static const String language = 'assets/svg/language.svg';
  static const String message = 'assets/svg/message.svg';
  static const String helpSupport = 'assets/svg/help_support.svg';
  static const String privacyPolicy = 'assets/svg/privacy_policy.svg';
  static const String termsAndCondition = 'assets/svg/terms_and_condition.svg';
  static const String aboutUs = 'assets/svg/about_us.svg';
  static const String address = 'assets/svg/address.svg';
  static const String cancellationPolicy = 'assets/svg/cancellation_policy.svg';
  static const String refundPolicy = 'assets/svg/refund_policy.svg';
  static const String profileMenuIcon = 'assets/svg/profile_menu_icon.svg';
  static const String couponMenuIcon = 'assets/svg/coupon_menu_icon.svg';
  static const String userDeleteIcon = 'assets/svg/user_delete_icon.svg';
  static const String locationDeleteIcon =
      'assets/svg/location_delete_icon.svg';
  static const String wishListRemoveIcon =
      'assets/svg/wish_list_remove_icon.svg';
  static const String lockIcon = 'assets/svg/lock.svg';
  static const String cartCouponIcon = 'assets/svg/cart_coupon_icon.svg';
  static const String orderFailed = 'assets/svg/order_failed.svg';
  static const String trackOrder = 'assets/svg/track_order.svg';
}
