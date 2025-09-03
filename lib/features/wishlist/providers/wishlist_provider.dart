import 'package:hneeds_user/common/models/api_response_model.dart';
import 'package:hneeds_user/common/models/product_model.dart';
import 'package:hneeds_user/features/wishlist/domain/models/wishlist_model.dart';
import 'package:hneeds_user/features/wishlist/domain/reposotories/wishlist_repo.dart';
import 'package:hneeds_user/helper/api_checker_helper.dart';
import 'package:hneeds_user/localization/language_constrants.dart';
import 'package:hneeds_user/main.dart';
import 'package:hneeds_user/helper/custom_snackbar_helper.dart';
import 'package:flutter/material.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo? wishListRepo;

  WishListProvider({required this.wishListRepo});

  List<Product>? _wishList;
  List<Product>? get wishList => _wishList;
  Product? _product;
  Product? get product => _product;
  List<int?> _wishIdList = [];
  List<int?> get wishIdList => _wishIdList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Product? wishProduct;

  void addToWishList(Product product) async {
    _wishList?.add(product);
    _wishIdList.add(product.id);
    int count = product.wishlistCount ?? 0;
    wishProduct = product.copyWith(count + 1);
    notifyListeners();
    ApiResponseModel apiResponse =
        await wishListRepo!.addWishList([product.id]);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(
          getTranslated('item_added_to', Get.context!), Get.context!,
          isError: false);
    } else {
      _wishList?.remove(product);
      _wishIdList.remove(product.id);
      // wishProduct = product.copyWith(count - 1);
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void removeFromWishList(Product product, BuildContext context) async {
    _wishList!.remove(product);
    _wishIdList.remove(product.id);
    int count = product.wishlistCount ?? 1;
    if (count > 0) {
      wishProduct = product.copyWith(count - 1);
    }
    notifyListeners();
    ApiResponseModel apiResponse =
        await wishListRepo!.removeWishList([product.id]);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(
          getTranslated('item_removed_from', Get.context!), Get.context!,
          isError: false);
    } else {
      _wishList!.add(product);
      _wishIdList.add(product.id);
      // wishProduct = product.copyWith(count + 1);
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getWishList() async {
    _isLoading = true;
    _wishList = [];
    _wishIdList = [];
    ApiResponseModel apiResponse = await wishListRepo!.getWishList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _wishList = [];
      _wishList!
          .addAll(WishListModel.fromJson(apiResponse.response!.data).products!);
      for (int i = 0; i < _wishList!.length; i++) {
        _wishIdList.add(_wishList![i].id);
      }
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearWishList() {
    _wishIdList = [];
    _wishList = [];
    notifyListeners();
  }
}
