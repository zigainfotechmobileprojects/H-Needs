import 'dart:convert';

import 'package:hneeds_user/common/models/api_response_model.dart';
import 'package:hneeds_user/common/models/category_model.dart';
import 'package:hneeds_user/common/models/feature_category_model.dart';
import 'package:hneeds_user/common/models/product_model.dart';
import 'package:hneeds_user/features/category/domain/reposotories/category_repo.dart';
import 'package:hneeds_user/helper/api_checker_helper.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({required this.categoryRepo});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? _subCategoryList;
  List<Product>? _categoryProductList;
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;
  int _categoryIndex = 0;
  int _categorySelectedIndex = -1;
  CategoryModel? _selectedCategoryModel;

  List<CategoryModel>? get categoryList => _categoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;
  List<Product>? get categoryProductList => _categoryProductList;
  bool get pageFirstIndex => _pageFirstIndex;
  bool get pageLastIndex => _pageLastIndex;
  int get categoryIndex => _categoryIndex;
  int get categorySelectedIndex => _categorySelectedIndex;
  CategoryModel? get selectedCategoryModel => _selectedCategoryModel;

  Future<ApiResponseModel?> getCategoryList(bool reload) async {
    ApiResponseModel? apiResponse;
    _subCategoryList = null;

    if (_categoryList == null || reload) {
      apiResponse = await categoryRepo.getCategoryList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _categoryList = [];
        apiResponse.response!.data.forEach(
            (category) => _categoryList!.add(CategoryModel.fromJson(category)));
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
      notifyListeners();
    }

    return apiResponse;
  }

  Future<void> getSubCategoryList(int categoryID, {int? subCategoryId}) async {
    _subCategoryList = null;
    ApiResponseModel apiResponse =
        await categoryRepo.getSubCategoryList(categoryID.toString());
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _subCategoryList = [];
      apiResponse.response!.data.forEach((category) =>
          _subCategoryList!.add(CategoryModel.fromJson(category)));
      getCategoryProductList(subCategoryId ?? categoryID);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  FeatureCategoryModel? _featureCategoryModel;
  FeatureCategoryModel? get featureCategoryMode => _featureCategoryModel;

  void getCategoryProductList(int? categoryID) async {
    _categoryProductList = null;
    notifyListeners();
    ApiResponseModel apiResponse =
        await categoryRepo.getCategoryProductList(categoryID.toString());

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _categoryProductList = [];
      apiResponse.response!.data.forEach(
          (category) => _categoryProductList!.add(Product.fromJson(category)));
      notifyListeners();
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  updateProductCurrentIndex(int index, int totalLength) {
    if (index > 0) {
      _pageFirstIndex = false;
      notifyListeners();
    } else {
      _pageFirstIndex = true;
      notifyListeners();
    }
    if (index + 1 == totalLength) {
      _pageLastIndex = true;
      notifyListeners();
    } else {
      _pageLastIndex = false;
      notifyListeners();
    }
  }

  void changeIndex(int selectedIndex, {bool notify = true}) {
    _categoryIndex = selectedIndex;
    if (notify) {
      notifyListeners();
    }
  }

  void changeSelectedIndex(int selectedIndex, {bool notify = true}) {
    _categorySelectedIndex = selectedIndex;
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getFeatureCategories(bool reload, {bool isUpdate = true}) async {
    if (reload) {
      _featureCategoryModel = null;

      if (isUpdate) {
        notifyListeners();
      }
    }
    if (_featureCategoryModel == null) {
      ApiResponseModel? response = await categoryRepo.getFeatureCategories();
      if (response.response != null &&
          response.response?.data != null &&
          response.response?.statusCode == 200) {
        _featureCategoryModel =
            FeatureCategoryModel.fromJson(jsonEncode(response.response?.data));
      } else {
        ApiCheckerHelper.checkApi(response);
      }
      notifyListeners();
    }
  }

  void selectCategoryById(int? id, {bool isUpdate = false}) {
    _selectedCategoryModel =
        _categoryList?.firstWhere((categoryModel) => categoryModel.id == id);

    if (isUpdate) {
      notifyListeners();
    }
  }
}
