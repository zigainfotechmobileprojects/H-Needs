import 'package:go_router/go_router.dart';
import 'package:hneeds_user/common/models/address_model.dart';
import 'package:hneeds_user/common/models/config_model.dart';
import 'package:hneeds_user/features/address/providers/location_provider.dart';
import 'package:hneeds_user/features/checkout/providers/checkout_provider.dart';
import 'package:hneeds_user/helper/checkout_helper.dart';
import 'package:hneeds_user/helper/phone_number_checker_helper.dart';
import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/localization/language_constrants.dart';
import 'package:hneeds_user/features/address/providers/address_provider.dart';
import 'package:hneeds_user/features/splash/providers/splash_provider.dart';
import 'package:hneeds_user/utill/dimensions.dart';
import 'package:hneeds_user/utill/routes.dart';
import 'package:hneeds_user/utill/styles.dart';
import 'package:hneeds_user/common/widgets/custom_button_widget.dart';
import 'package:hneeds_user/helper/custom_snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AddressButtonWidget extends StatelessWidget {
  final bool isUpdateEnable;
  final bool fromCheckout;
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final TextEditingController streetNumberController;
  final TextEditingController houseNumberController;
  final TextEditingController floorNumberController;
  final AddressModel? address;
  final String location;
  final String countryCode;
  final int? cityId;
  final int? stateId;
  final int? countryId;
  final TextEditingController? pincodeController;

  const AddressButtonWidget({
    super.key,
    required this.isUpdateEnable,
    required this.fromCheckout,
    required this.contactPersonNumberController,
    required this.contactPersonNameController,
    required this.streetNumberController,
    required this.floorNumberController,
    required this.houseNumberController,
    required this.address,
    required this.location,
    required this.countryCode,
    this.cityId,
    this.stateId,
    this.countryId,
    this.pincodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, _) {
        return Column(
          children: [
            // Show status or error messages
            if (addressProvider.addressStatusMessage != null &&
                addressProvider.addressStatusMessage!.isNotEmpty)
              _buildMessageRow(
                  addressProvider.addressStatusMessage!, Colors.green),
            if (addressProvider.errorMessage != null &&
                addressProvider.errorMessage!.isNotEmpty)
              _buildMessageRow(addressProvider.errorMessage!, Colors.red),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Button
            Container(
              height: 50,
              width: Dimensions.webScreenWidth,
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, _) {
                  return CustomButtonWidget(
                    isLoading: addressProvider.isLoading,
                    btnTxt: isUpdateEnable
                        ? getTranslated('update_address', context)
                        : getTranslated('save_location', context),
                    onTap: locationProvider.isLoading
                        ? null
                        : () async => _onPressAction(locationProvider, context),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageRow(String message, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(backgroundColor: color, radius: 5),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: rubikMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall, color: color, height: 1),
          ),
        ),
      ],
    );
  }

  Future<void> _onPressAction(
      LocationProvider locationProvider, BuildContext context) async {
    final addressProvider = context.read<AddressProvider>();
    final checkoutProvider = context.read<CheckoutProvider>();
    final splashProvider = context.read<SplashProvider>();

    // ✅ Get dynamic city, state, country IDs
    final selectedCityId = locationProvider.selectedCityId;
    final selectedStateId = locationProvider.selectedStateId;
    final selectedCountryId = locationProvider.selectedCountryId;

    if (selectedCityId == null) {
      showCustomSnackBar('Please select a valid city before saving.', context);
      return;
    }

    // ✅ Validate pincode
    // if (pincodeController == null || pincodeController!.text.trim().isEmpty) {
    //   showCustomSnackBar('Please enter a pincode', context);
    //   return;
    // }

    // ✅ Validate phone number
    String phone = countryCode + contactPersonNumberController.text.trim();
    bool isValidPhone =
        PhoneNumberCheckerHelper.isPhoneValidWithCountryCode(phone);
    if (!isValidPhone) {
      showCustomSnackBar(
          getTranslated('invalid_phone_number', context), context);
      return;
    }

    // ✅ Check service availability
    List<Branches> branches = splashProvider.configModel!.branches ?? [];
    bool isAvailable = branches.length == 1 &&
        (branches[0].latitude == null || branches[0].latitude!.isEmpty);

    if (!isAvailable) {
      if (splashProvider.configModel?.googleMapStatus ?? false) {
        for (Branches branch in branches) {
          double distance = Geolocator.distanceBetween(
                  double.parse(branch.latitude!),
                  double.parse(branch.longitude!),
                  double.tryParse(
                          locationProvider.pickedAddressLatitude ?? '') ??
                      locationProvider.currentPosition.latitude,
                  double.tryParse(
                          locationProvider.pickedAddressLongitude ?? '') ??
                      locationProvider.currentPosition.longitude) /
              1000;

          if (distance < branch.coverage!) {
            isAvailable = true;
            break;
          }
        }
      } else {
        isAvailable = true;
      }
    }

    if (!isAvailable) {
      showCustomSnackBar(
          getTranslated('service_is_not_available', context), context);
      return;
    }

    // ✅ Build AddressModel with verified IDs
    AddressModel addressModel = AddressModel(
      addressType:
          addressProvider.getAllAddressType[addressProvider.selectAddressIndex],
      contactPersonName: contactPersonNameController.text.trim(),
      contactPersonNumber: phone,
      address: locationProvider.address,
      latitude: (splashProvider.configModel?.googleMapStatus ?? false)
          ? (locationProvider.pickedAddressLatitude?.isNotEmpty ?? false)
              ? locationProvider.pickedAddressLatitude.toString()
              : locationProvider.currentPosition.latitude.toString()
          : null,
      longitude: (splashProvider.configModel?.googleMapStatus ?? false)
          ? (locationProvider.pickedAddressLongitude?.isNotEmpty ?? false)
              ? locationProvider.pickedAddressLongitude.toString()
              : locationProvider.currentPosition.longitude.toString()
          : null,
      floorNumber: floorNumberController.text,
      houseNumber: houseNumberController.text,
      streetNumber: streetNumberController.text,
      cityId: selectedCityId,
      stateId: selectedStateId,
      countryId: selectedCountryId,
      pincode: pincodeController!.text.trim(), // ✅ guaranteed not null
    );

    // ✅ Add or update address
    if (isUpdateEnable) {
      addressModel.id = address?.id;
      addressModel.userId = address?.userId;
      addressModel.method = 'put';
      await addressProvider.updateAddress(context,
          addressModel: addressModel, addressId: addressModel.id);
    } else {
      await addressProvider.addAddress(addressModel, context).then((value) {
        if (value.isSuccess) {
          if (fromCheckout) {
            addressProvider.initAddressList();
            checkoutProvider.setOrderAddressIndex(-1);
            CheckOutHelper.selectDeliveryAddressAuto(
                orderType: checkoutProvider.orderType,
                isLoggedIn: true,
                lastAddress: null);
          }

          if (ResponsiveHelper.isDesktop(context) &&
              Navigator.canPop(context)) {
            GoRouter.of(context).pop();
          } else if (!ResponsiveHelper.isDesktop(context)) {
            Navigator.pop(context);
          } else {
            RouteHelper.getAddressRoute(context,
                action: RouteAction.pushNamedAndRemoveUntil);
          }

          showCustomSnackBar(value.message, context, isError: false);
        } else {
          showCustomSnackBar(value.message, context);
        }
      });
    }
  }
}