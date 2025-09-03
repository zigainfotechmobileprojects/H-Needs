import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hneeds_user/common/models/api_response_model.dart';
import 'package:hneeds_user/common/models/response_model.dart';
import 'package:hneeds_user/common/models/userinfo_model.dart';
import 'package:hneeds_user/features/profile/domain/reposotories/profile_repo.dart';
import 'package:hneeds_user/helper/api_checker_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;
  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;
  String? _countryCode;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? get countryCode => _countryCode;

  Future<void> getUserInfo() async {
    ApiResponseModel apiResponse = await profileRepo!.getUserInfo();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
      profileRepo!.clearUserId().then((value) {
        saveUserId('${_userInfoModel!.id}');
      });
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    notifyListeners();
  }

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel,
      String password, XFile? file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    print(
        "---------(UPDATE USER INFO)------------${updateUserModel.toJson().toString()}");
    http.StreamedResponse response = await profileRepo!
        .updateProfile(updateUserModel, password, file, token);

    Map map = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(false, '${map['errors'][0]['message']}');
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void saveUserId(String userId) => profileRepo!.saveUserID(userId);

  String getUserId() => profileRepo!.getUserId();

  void setCountryCode(String countryCode, {bool isUpdate = true}) {
    if (!countryCode.contains('+')) {
      countryCode = "+$countryCode";
    }
    _countryCode = countryCode;
    if (isUpdate) {
      notifyListeners();
    }
  }
}
