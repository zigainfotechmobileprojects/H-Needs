import 'package:hneeds_user/data/datasource/remote/dio/dio_client.dart';
import 'package:hneeds_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:hneeds_user/common/models/api_response_model.dart';
import 'package:hneeds_user/utill/app_constants.dart';

class BannerRepo {
  final DioClient? dioClient;
  BannerRepo({required this.dioClient});

  Future<ApiResponseModel> getBannerList() async {
    try {
      final response = await dioClient!.get(AppConstants.bannerUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getProductDetails(String productID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.productDetailsUri}$productID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
