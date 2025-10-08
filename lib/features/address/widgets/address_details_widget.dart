import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hneeds_user/common/models/address_model.dart';
import 'package:hneeds_user/common/models/location_model.dart';
import 'package:hneeds_user/common/widgets/custom_text_field_widget.dart';
import 'package:hneeds_user/features/address/providers/address_provider.dart';
import 'package:hneeds_user/features/address/providers/location_provider.dart';
import 'package:hneeds_user/features/address/widgets/address_button_widget.dart';
import 'package:hneeds_user/helper/auth_helper.dart';
import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/localization/language_constrants.dart';
import 'package:hneeds_user/utill/color_resources.dart';
import 'package:hneeds_user/utill/dimensions.dart';
import 'package:hneeds_user/utill/styles.dart';
import 'package:provider/provider.dart';

class AddressDetailsWidget extends StatefulWidget {
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final FocusNode addressNode;
  final FocusNode nameNode;
  final FocusNode numberNode;
  final bool isUpdateEnable;
  final bool fromCheckout;
  final AddressModel? address;
  final TextEditingController locationTextController;
  final TextEditingController streetNumberController;
  final TextEditingController houseNumberController;
  final TextEditingController florNumberController;
  final FocusNode stateNode;
  final FocusNode houseNode;
  final FocusNode florNode;
  final TextEditingController pincodeController;

  // Add these as fields
  final int? cityId;
  final int? stateId;
  final int? countryId;

  const AddressDetailsWidget({
    super.key,
    required this.contactPersonNameController,
    required this.contactPersonNumberController,
    required this.addressNode,
    required this.nameNode,
    required this.numberNode,
    required this.isUpdateEnable,
    required this.fromCheckout,
    required this.address,
    required this.locationTextController,
    required this.streetNumberController,
    required this.houseNumberController,
    required this.stateNode,
    required this.houseNode,
    required this.florNumberController,
    required this.florNode,
    required this.pincodeController,
    this.cityId,
    this.stateId,
    this.countryId,
  });

  @override
  State<AddressDetailsWidget> createState() => _AddressDetailsWidgetState();
}

class _AddressDetailsWidgetState extends State<AddressDetailsWidget> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  CityModel? selectedCity;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final locationProvider = context.read<LocationProvider>();
      await locationProvider.getAllLocationData();
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  /// Helper to get city ID based on selection or typed text
  int? _getCityId(BuildContext context) {
    final locationProvider = context.read<LocationProvider>();

    // Already selected city
    if (locationProvider.selectedCityId != null)
      return locationProvider.selectedCityId;

    // Typed city
    final typedCity = _cityController.text.trim();
    if (typedCity.isEmpty) return null;

    CityModel? match;
    try {
      match = locationProvider.flatCityList.firstWhere(
        (c) => c.cityName.toLowerCase() == typedCity.toLowerCase(),
      );
    } catch (e) {
      match = null;
    }

    if (match != null) {
      locationProvider.selectCityFromSearch(match);
      _stateController.text = match.stateName;
      _countryController.text = match.countryName;
      return match.cityId;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Padding(
          padding: ResponsiveHelper.isDesktop(context)
              ? const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge,
                  vertical: Dimensions.paddingSizeLarge,
                )
              : EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Delivery Address ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  getTranslated('delivery_address', context),
                  style: rubikRegular.copyWith(
                    color: ColorResources.getGreyBunkerColor(context),
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ),

              // --- Address Line ---
              Text(
                getTranslated('address_line_01', context),
                style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                hintText: getTranslated('address_line_02', context),
                isShowBorder: true,
                inputType: TextInputType.streetAddress,
                inputAction: TextInputAction.next,
                focusNode: widget.addressNode,
                nextFocus: widget.nameNode,
                controller: widget.locationTextController,
                onChanged: (String? value) =>
                    locationProvider.setAddress = value,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // --- Street Number ---
              Text(
                '${getTranslated('street', context)} ${getTranslated('number', context)}',
                style: rubikRegular.copyWith(
                    color: Theme.of(context).hintColor.withOpacity(0.6)),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                hintText: getTranslated('ex_10_th', context),
                isShowBorder: true,
                inputType: TextInputType.streetAddress,
                inputAction: TextInputAction.next,
                focusNode: widget.stateNode,
                nextFocus: widget.houseNode,
                controller: widget.streetNumberController,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // --- Pincode ---
              Text(
                getTranslated('pincode', context),
                style: rubikRegular.copyWith(
                    color: Theme.of(context).hintColor.withOpacity(0.6)),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                hintText: getTranslated('enter_pincode', context),
                isShowBorder: true,
                inputType: TextInputType.number,
                inputAction: TextInputAction.next,
                maxLength: 6,
                controller: widget.pincodeController, // <- fixed
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // --- House / Floor ---
              Text(
                '${getTranslated('house', context)} / ${getTranslated('floor', context)} ${getTranslated('number', context)}',
                style: rubikRegular.copyWith(
                    color: Theme.of(context).hintColor.withOpacity(0.6)),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFieldWidget(
                      hintText: getTranslated('ex_2', context),
                      isShowBorder: true,
                      inputType: TextInputType.streetAddress,
                      inputAction: TextInputAction.next,
                      focusNode: widget.houseNode,
                      nextFocus: widget.florNode,
                      controller: widget.houseNumberController,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeLarge),
                  Expanded(
                    child: CustomTextFieldWidget(
                      hintText: getTranslated('ex_2b', context),
                      isShowBorder: true,
                      inputType: TextInputType.streetAddress,
                      inputAction: TextInputAction.next,
                      focusNode: widget.florNode,
                      nextFocus: widget.nameNode,
                      controller: widget.florNumberController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // --- City (Searchable) ---
              Text(
                getTranslated('city', context),
                style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              if (locationProvider.isLocationDataLoading)
                const Center(child: CircularProgressIndicator())
              else if (locationProvider.flatCityList.isEmpty)
                Text('No cities available', style: rubikRegular)
              else
                TypeAheadField<CityModel>(
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: _cityController,
                      focusNode: focusNode,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: getTranslated('select_city', context),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeDefault,
                            horizontal: 22),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Dimensions.radiusSizeDefault),
                          borderSide: BorderSide(
                              width: 1,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Dimensions.radiusSizeDefault),
                          borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5)),
                        ),
                      ),
                    );
                  },
                  suggestionsCallback: (pattern) {
                    return locationProvider.flatCityList
                        .where((city) => city.cityName
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, CityModel city) {
                    return ListTile(title: Text(city.cityName));
                  },
                  onSelected: (CityModel city) {
                    setState(() {
                      selectedCity = city;
                      _cityController.text = city.cityName;
                      _stateController.text = city.stateName;
                      _countryController.text = city.countryName;
                    });
                    locationProvider.selectCityFromSearch(city);
                  },
                ),

              const SizedBox(height: Dimensions.paddingSizeLarge),

              // --- State ---
              Text(
                getTranslated('state', context),
                style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                hintText: getTranslated('state', context),
                isShowBorder: true,
                isEnabled: false,
                controller: _stateController,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // --- Country ---
              Text(
                getTranslated('country', context),
                style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                hintText: getTranslated('country', context),
                isShowBorder: true,
                isEnabled: false,
                controller: _countryController,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // --- Contact Person Name ---
              Text(
                getTranslated('contact_person_name', context),
                style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                hintText: getTranslated('enter_contact_person_name', context),
                isShowBorder: true,
                inputType: TextInputType.name,
                controller: widget.contactPersonNameController,
                focusNode: widget.nameNode,
                nextFocus: widget.numberNode,
                inputAction: TextInputAction.next,
                capitalization: TextCapitalization.words,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // --- Contact Person Number ---
              Text(
                getTranslated('contact_person_number', context),
                style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                hintText: getTranslated('enter_contact_person_number', context),
                isShowBorder: true,
                inputType: TextInputType.phone,
                inputAction: TextInputAction.done,
                focusNode: widget.numberNode,
                controller: widget.contactPersonNumberController,
                countryDialCode: context.read<AddressProvider>().countryCode,
                onCountryChanged: (CountryCode value) {
                  context
                      .read<AddressProvider>()
                      .setCountryCode(value.dialCode ?? '', isUpdate: true);
                },
                onChanged: (String text) =>
                    AuthHelper.identifyEmailOrNumber(text, context),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // --- Submit Button ---
              if (ResponsiveHelper.isDesktop(context))
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge),
                  child: AddressButtonWidget(
                    isUpdateEnable: widget.isUpdateEnable,
                    fromCheckout: widget.fromCheckout,
                    contactPersonNumberController:
                        widget.contactPersonNumberController,
                    contactPersonNameController:
                        widget.contactPersonNameController,
                    address: widget.address,
                    location: widget.locationTextController.text,
                    streetNumberController: widget.streetNumberController,
                    houseNumberController: widget.houseNumberController,
                    floorNumberController: widget.florNumberController,
                    countryCode:
                        context.read<AddressProvider>().countryCode ?? '',
                    cityId: _getCityId(context),
                    stateId: locationProvider.selectedStateId,
                    countryId: locationProvider.selectedCountryId,
                    pincodeController: widget.pincodeController, // <- fixed
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
