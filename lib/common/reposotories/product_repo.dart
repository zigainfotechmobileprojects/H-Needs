import 'package:hneeds_user/common/enums/product_filter_type_enum.dart';
import 'package:hneeds_user/data/datasource/remote/dio/dio_client.dart';
import 'package:hneeds_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:hneeds_user/common/models/review_body_model.dart';
import 'package:hneeds_user/common/models/api_response_model.dart';
import 'package:hneeds_user/helper/product_helper.dart';
import 'package:hneeds_user/utill/app_constants.dart';

class ProductRepo {
  final DioClient? dioClient;

  ProductRepo({required this.dioClient});

  Future<ApiResponseModel> getLatestProductList(
      int offset, int limit, ProductFilterType? filterType) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.latestProductUri}?limit=$limit&&offset=$offset${filterType != null ? '&sort_by=${ProductHelper.getProductFilterTypeValue(filterType)}' : ''}',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getOfferProductList() async {
    try {
      final response = await dioClient!.get(
        AppConstants.offerProductUri,
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getProductDetails(String productID) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.productDetailsUri}$productID',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> searchProduct(String productId) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.searchProductUri}$productId',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> submitReview(ReviewBodyModel reviewBody) async {
    try {
      final response =
          await dioClient!.post(AppConstants.reviewUri, data: reviewBody);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> submitDeliveryManReview(
      ReviewBodyModel reviewBody) async {
    try {
      final response = await dioClient!
          .post(AppConstants.deliverManReviewUri, data: reviewBody);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getProductReviewList(int? productID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.productReviewUri}$productID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getFlashSale(
      int offset, ProductFilterType? filterType) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.flashSale}?limit=15&&offset=$offset${filterType != null ? '&sort_by=${ProductHelper.getProductFilterTypeValue(filterType)}' : ''}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getNewArrivalProducts(int offset) async {
    try {
      final response = await dioClient!.get(AppConstants.newArrivalProducts);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
