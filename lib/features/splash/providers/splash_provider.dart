import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hneeds_user/common/models/api_response_model.dart';
import 'package:hneeds_user/common/models/config_model.dart';
import 'package:hneeds_user/common/models/delivery_info_model.dart';
import 'package:hneeds_user/features/splash/domain/models/policy_model.dart';
import 'package:hneeds_user/features/splash/domain/reposotories/splash_repo.dart';
import 'package:hneeds_user/helper/api_checker_helper.dart';
import 'package:hneeds_user/helper/maintenance_helper.dart';
import 'package:hneeds_user/main.dart';
import 'package:hneeds_user/features/auth/providers/auth_provider.dart';
import 'package:hneeds_user/utill/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:hneeds_user/utill/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;
  final SharedPreferences? sharedPreferences;
  SplashProvider({required this.splashRepo, this.sharedPreferences});

  ConfigModel? _configModel;
  PolicyModel? _policyModel;
  List<DeliveryInfoModel>? _deliveryInfoModelList;
  bool _cookiesShow = true;

  BaseUrls? _baseUrls;
  final DateTime _currentTime = DateTime.now();

  ConfigModel? get configModel => _configModel;
  PolicyModel? get policyModel => _policyModel;
  List<DeliveryInfoModel>? get deliveryInfoModelList => _deliveryInfoModelList;
  BaseUrls? get baseUrls => _baseUrls;
  DateTime get currentTime => _currentTime;

  bool get cookiesShow => _cookiesShow;

  Future<bool> initConfig({bool? fromNotification}) async {
    ApiResponseModel apiResponse = await splashRepo!.getConfig();
    bool isSuccess;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;
      isSuccess = true;

      if (!MaintenanceHelper.isMaintenanceModeEnable(configModel)) {
        if (MaintenanceHelper.checkWebMaintenanceMode(configModel) ||
            MaintenanceHelper.checkCustomerMaintenanceMode(configModel)) {
          if (MaintenanceHelper.isCustomizeMaintenance(configModel)) {
            DateTime now = DateTime.now();
            DateTime specifiedDateTime = DateTime.parse(_configModel!
                .maintenanceMode!.maintenanceTypeAndDuration!.startDate!);

            Duration difference = specifiedDateTime.difference(now);

            if (difference.inMinutes > 0 &&
                (difference.inMinutes < 60 || difference.inMinutes == 60)) {
              _startTimer(specifiedDateTime);
            }
          }
        }
      }

      if (fromNotification ?? false) {
        if (kDebugMode) {
          print(
              "Maintenance Mode => ${MaintenanceHelper.isMaintenanceModeEnable(configModel)}");
        }
        if (MaintenanceHelper.isMaintenanceModeEnable(configModel) &&
            (MaintenanceHelper.checkCustomerMaintenanceMode(configModel) ||
                MaintenanceHelper.checkWebMaintenanceMode(configModel))) {
          RouteHelper.getMaintainRoute(Get.context!,
              action: RouteAction.pushNamedAndRemoveUntil);
        } else if (!MaintenanceHelper.isMaintenanceModeEnable(configModel)) {
          RouteHelper.getMainRoute(Get.context!,
              action: RouteAction.pushNamedAndRemoveUntil);
        }
      }

      // if(!kIsWeb && !Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()){
      //   await ;
      // }

      Future.delayed(const Duration(milliseconds: 500), () {
        final AuthProvider authProvider =
            Provider.of<AuthProvider>(Get.context!, listen: false);
        if (authProvider.getGuestId() == null && !authProvider.isLoggedIn()) {
          print("-----HERE AM I");
          authProvider.addOrUpdateGuest();
        }
        authProvider.updateToken();

        if (kDebugMode) {
          print("Guest Id ==>${authProvider.getGuestId()}");
        }
      });

      notifyListeners();
    } else {
      isSuccess = false;
      ApiCheckerHelper.checkApi(apiResponse);
    }
    return isSuccess;
  }

  Future<void> getPolicyPage({bool reload = false}) async {
    if (_policyModel == null || reload) {
      ApiResponseModel apiResponse = await splashRepo!.getPolicyPage();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _policyModel = PolicyModel.fromJson(apiResponse.response!.data);

        notifyListeners();
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }
  }

  void _startTimer(DateTime startTime) {
    Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      DateTime now = DateTime.now();
      if (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) {
        timer.cancel();
        RouteHelper.getMaintainRoute(Get.context!,
            action: RouteAction.pushNamedAndRemoveUntil);
      }
    });
  }

  Future<void> getDeliveryInfo() async {
    _deliveryInfoModelList = [];
    ApiResponseModel apiResponse = await splashRepo!.getDeliveryInfo();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      print(
          "--------------DELIVERY INFO------------${apiResponse.response?.data}");
      apiResponse.response?.data.forEach((deliveryInfo) {
        _deliveryInfoModelList?.add(DeliveryInfoModel.fromJson(deliveryInfo));
      });
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }

  bool showLang() {
    return splashRepo!.showLang();
  }

  void disableLang() {
    splashRepo!.disableLang();
  }

  void cookiesStatusChange(String? data) {
    if (data != null) {
      splashRepo!.sharedPreferences!
          .setString(AppConstants.cookingManagement, data);
    }
    _cookiesShow = false;
    notifyListeners();
  }

  bool getAcceptCookiesStatus(String? data) =>
      splashRepo!.sharedPreferences!
              .getString(AppConstants.cookingManagement) !=
          null &&
      splashRepo!.sharedPreferences!
              .getString(AppConstants.cookingManagement) ==
          data;
}
