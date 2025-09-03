import 'package:hneeds_user/common/models/product_model.dart';

class OrderModel {
  int? _id;
  int? _userId;
  double? _orderAmount;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  String? _paymentStatus;
  String? _orderStatus;
  double? _totalTaxAmount;
  String? _paymentMethod;
  String? _transactionReference;
  int? _deliveryAddressId;
  String? _createdAt;
  String? _updatedAt;
  int? _deliveryManId;
  double? _deliveryCharge;
  String? _orderNote;
  List<int>? _addOnIds;
  List<Details>? _details;
  DeliveryMan? _deliveryMan;
  int? _detailsCount;
  String? _orderType;
  int? _deliverymanReviewCount;
  DeliveryAddress? _deliveryAddress;
  double? _extraDiscount;
  int? _totalQuantity;
  int? _branchId;

  OrderModel({
    int? id,
    int? userId,
    double? orderAmount,
    double? couponDiscountAmount,
    String? couponDiscountTitle,
    String? paymentStatus,
    String? orderStatus,
    double? totalTaxAmount,
    String? paymentMethod,
    String? transactionReference,
    int? deliveryAddressId,
    String? createdAt,
    String? updatedAt,
    String? checked,
    int? deliveryManId,
    double? deliveryCharge,
    String? orderNote,
    List<int>? addOnIds,
    List<Details>? details,
    DeliveryMan? deliveryMan,
    int? detailsCount,
    String? orderType,
    int? deliveryManReviewCount,
    DeliveryAddress? deliveryAddress,
    double? extraDiscount,
    int? totalQuantity,
    int? branchId,
  }) {
    _id = id;
    _userId = userId;
    _orderAmount = orderAmount;
    _couponDiscountAmount = couponDiscountAmount;
    _couponDiscountTitle = couponDiscountTitle;
    _paymentStatus = paymentStatus;
    _orderStatus = orderStatus;
    _totalTaxAmount = totalTaxAmount;
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    _deliveryAddressId = deliveryAddressId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deliveryManId = deliveryManId;
    _deliveryCharge = deliveryCharge;
    _orderNote = orderNote;
    _addOnIds = addOnIds;
    _details = details;
    _deliveryMan = deliveryMan;
    _detailsCount = detailsCount;
    _orderType = orderType;
    _deliverymanReviewCount = deliveryManReviewCount;
    _deliveryAddress = deliveryAddress;
    _extraDiscount = extraDiscount;
    _totalQuantity = totalQuantity;
    _branchId = branchId;
  }

  int? get id => _id;
  int? get userId => _userId;
  double? get orderAmount => _orderAmount;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  String? get paymentStatus => _paymentStatus;
  String? get orderStatus => _orderStatus;
  double? get totalTaxAmount => _totalTaxAmount;
  // ignore: unnecessary_getters_setters
  String? get paymentMethod => _paymentMethod;
  // ignore: unnecessary_getters_setters
  set paymentMethod(String? method) => _paymentMethod = method;
  String? get transactionReference => _transactionReference;
  int? get deliveryAddressId => _deliveryAddressId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get deliveryManId => _deliveryManId;
  double? get deliveryCharge => _deliveryCharge;
  String? get orderNote => _orderNote;
  List<int>? get addOnIds => _addOnIds;
  List<Details>? get details => _details;
  DeliveryMan? get deliveryMan => _deliveryMan;
  int? get detailsCount => _detailsCount;
  String? get orderType => _orderType;
  int? get deliveryManReviewCount => _deliverymanReviewCount;
  DeliveryAddress? get deliveryAddress => _deliveryAddress;
  double? get extraDiscount => _extraDiscount;
  int? get totalQuantity => _totalQuantity;
  int? get branchId => _branchId;

  OrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _orderAmount = json['order_amount'].toDouble();
    _couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    _couponDiscountTitle = json['coupon_discount_title'];
    _paymentStatus = json['payment_status'];
    _orderStatus = json['order_status'];
    _totalTaxAmount = json['total_tax_amount'].toDouble();
    _paymentMethod = json['payment_method'];
    _transactionReference = json['transaction_reference'];
    _deliveryAddressId = json['delivery_address_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deliveryManId = json['delivery_man_id'];
    _deliveryCharge = json['delivery_charge'].toDouble();
    _orderNote = json['order_note'];
    _detailsCount = json['details_count'];
    if (json['add_on_ids'] != null) {
      _addOnIds = json['add_on_ids'].cast<int>();
    }
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details!.add(Details.fromJson(v));
      });
    }
    _deliveryMan = json['delivery_man'] != null
        ? DeliveryMan.fromJson(json['delivery_man'])
        : null;
    _orderType = json['order_type'];
    _deliverymanReviewCount = json['deliveryman_review_count'];
    _deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;

    try {
      _extraDiscount = double.parse(json['extra_discount']);
    } catch (e) {
      _extraDiscount = json['extra_discount'];
    }
    _totalQuantity = int.tryParse('${json['total_quantity']}');
    _branchId = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['order_amount'] = _orderAmount;
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['payment_status'] = _paymentStatus;
    data['order_status'] = _orderStatus;
    data['total_tax_amount'] = _totalTaxAmount;
    data['payment_method'] = _paymentMethod;
    data['transaction_reference'] = _transactionReference;
    data['delivery_address_id'] = _deliveryAddressId;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['delivery_man_id'] = _deliveryManId;
    data['delivery_charge'] = _deliveryCharge;
    data['order_note'] = _orderNote;
    data['add_on_ids'] = _addOnIds;
    data['details_count'] = _detailsCount;
    if (_details != null) {
      data['details'] = _details!.map((v) => v.toJson()).toList();
    }
    if (_deliveryMan != null) {
      data['delivery_man'] = _deliveryMan!.toJson();
    }
    data['order_type'] = _orderType;
    data['deliveryman_review_count'] = _deliverymanReviewCount;
    if (_deliveryAddress != null) {
      data['delivery_address'] = _deliveryAddress!.toJson();
    }
    data['extra_discount'] = _extraDiscount;
    data['total_quantity'] = _totalQuantity;
    return data;
  }
}

class Details {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  String? _variation;
  double? _discountOnProduct;
  String? _discountType;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;
  String? _addOnIds;
  String? _variant;

  Details(
      {int? id,
      int? productId,
      int? orderId,
      double? price,
      String? productDetails,
      String? variation,
      double? discountOnProduct,
      String? discountType,
      int? quantity,
      double? taxAmount,
      String? createdAt,
      String? updatedAt,
      String? addOnIds,
      String? variant}) {
    _id = id;
    _productId = productId;
    _orderId = orderId;
    _price = price;
    _variation = variation;
    _discountOnProduct = discountOnProduct;
    _discountType = discountType;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _addOnIds = addOnIds;
    _variant = variant;
  }

  int? get id => _id;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  String? get variation => _variation;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get addOnIds => _addOnIds;
  String? get variant => _variant;

  Details.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _price = json['price'].toDouble();
    _variation = json['variation'];
    _discountOnProduct = json['discount_on_product'].toDouble();
    _discountType = json['discount_type'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _addOnIds = json['add_on_ids'];
    _variant = json['variant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['product_id'] = _productId;
    data['order_id'] = _orderId;
    data['price'] = _price;
    data['variation'] = _variation;
    data['discount_on_product'] = _discountOnProduct;
    data['discount_type'] = _discountType;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['add_on_ids'] = _addOnIds;
    data['variant'] = _variant;
    return data;
  }
}

class DeliveryMan {
  int? _id;
  String? _fName;
  String? _lName;
  String? _phone;
  String? _email;
  String? _identityNumber;
  String? _identityType;
  String? _identityImage;
  String? _image;
  String? _password;
  String? _createdAt;
  String? _updatedAt;
  String? _authToken;
  List<Rating>? _rating;

  DeliveryMan(
      {int? id,
      String? fName,
      String? lName,
      String? phone,
      String? email,
      String? identityNumber,
      String? identityType,
      String? identityImage,
      String? image,
      String? password,
      String? createdAt,
      String? updatedAt,
      String? authToken,
      List<Rating>? rating}) {
    _id = id;
    _fName = fName;
    _lName = lName;
    _phone = phone;
    _email = email;
    _identityNumber = identityNumber;
    _identityType = identityType;
    _identityImage = identityImage;
    _image = image;
    _password = password;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _authToken = authToken;
    _rating = rating;
  }

  int? get id => _id;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get phone => _phone;
  String? get email => _email;
  String? get identityNumber => _identityNumber;
  String? get identityType => _identityType;
  String? get identityImage => _identityImage;
  String? get image => _image;
  String? get password => _password;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get authToken => _authToken;
  List<Rating>? get rating => _rating;

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _email = json['email'];
    _identityNumber = json['identity_number'];
    _identityType = json['identity_type'];
    _identityImage = json['identity_image'];
    _image = json['image'];
    _password = json['password'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _authToken = json['auth_token'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating!.add(Rating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['f_name'] = _fName;
    data['l_name'] = _lName;
    data['phone'] = _phone;
    data['email'] = _email;
    data['identity_number'] = _identityNumber;
    data['identity_type'] = _identityType;
    data['identity_image'] = _identityImage;
    data['image'] = _image;
    data['password'] = _password;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['auth_token'] = _authToken;
    if (_rating != null) {
      data['rating'] = _rating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryAddress {
  int? _id;
  String? _addressType;
  String? _contactPersonNumber;
  String? _address;
  String? _latitude;
  String? _longitude;
  String? _createdAt;
  String? _updatedAt;
  int? _userId;
  String? _contactPersonName;

  DeliveryAddress(
      {int? id,
      String? addressType,
      String? contactPersonNumber,
      String? address,
      String? latitude,
      String? longitude,
      String? createdAt,
      String? updatedAt,
      int? userId,
      String? contactPersonName}) {
    _id = id;
    _addressType = addressType;
    _contactPersonNumber = contactPersonNumber;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _userId = userId;
    _contactPersonName = contactPersonName;
  }

  int? get id => _id;
  String? get addressType => _addressType;
  String? get contactPersonNumber => _contactPersonNumber;
  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get userId => _userId;
  String? get contactPersonName => _contactPersonName;

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type'];
    _contactPersonNumber = json['contact_person_number'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _userId = json['user_id'];
    _contactPersonName = json['contact_person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['address_type'] = _addressType;
    data['contact_person_number'] = _contactPersonNumber;
    data['address'] = _address;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['user_id'] = _userId;
    data['contact_person_name'] = _contactPersonName;
    return data;
  }
}
