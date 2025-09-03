import 'package:hneeds_user/data/datasource/remote/dio/dio_client.dart';
import 'package:hneeds_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:hneeds_user/common/models/api_response_model.dart';
import 'package:hneeds_user/utill/app_constants.dart';

class WishListRepo {
  final DioClient? dioClient;

  WishListRepo({required this.dioClient});

  Future<ApiResponseModel> getWishList() async {
    try {
      final response = await dioClient!.get(AppConstants.wishListGetUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> addWishList(List<int?> productID) async {
    try {
      final response = await dioClient!
          .post(AppConstants.addWishListUri, data: {'product_ids': productID});

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> removeWishList(List<int?> productID) async {
    try {
      final response = await dioClient!.delete(AppConstants.removeWishListUri,
          data: {'product_ids': productID, '_method': 'delete'});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
