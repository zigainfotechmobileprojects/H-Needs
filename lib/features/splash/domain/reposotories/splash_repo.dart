import 'package:hneeds_user/data/datasource/remote/dio/dio_client.dart';
import 'package:hneeds_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:hneeds_user/common/models/api_response_model.dart';
import 'package:hneeds_user/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponseModel> getConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.configUri);
      print("Response from api =====${response.data}");
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getPolicyPage() async {
    try {
      final response = await dioClient!.get(AppConstants.policyPage);
      print("Response from api =====${response.data}");
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getDeliveryInfo() async {
    try {
      final response = await dioClient!
          .get("${AppConstants.baseUrl}${AppConstants.getDeliveryInfo}");
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences!.containsKey(AppConstants.theme)) {
      return sharedPreferences!.setBool(AppConstants.theme, false);
    }
    if (!sharedPreferences!.containsKey(AppConstants.countryCode)) {
      return sharedPreferences!.setString(
          AppConstants.countryCode, AppConstants.languages[0].countryCode!);
    }
    if (!sharedPreferences!.containsKey(AppConstants.languageCode)) {
      return sharedPreferences!.setString(
          AppConstants.languageCode, AppConstants.languages[0].languageCode!);
    }
    if (!sharedPreferences!.containsKey(AppConstants.onBoardingSkip)) {
      return sharedPreferences!.setBool(AppConstants.onBoardingSkip, false);
    }
    if (!sharedPreferences!.containsKey(AppConstants.langSkip)) {
      sharedPreferences!.setBool(AppConstants.langSkip, true);
    }
    if (!sharedPreferences!.containsKey(AppConstants.cartList)) {
      return sharedPreferences!.setStringList(AppConstants.cartList, []);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }

  void disableLang() {
    sharedPreferences!.setBool(AppConstants.langSkip, false);
  }

  bool showLang() {
    return sharedPreferences!.getBool(AppConstants.langSkip) ?? false;
  }
}
