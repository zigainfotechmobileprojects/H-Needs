import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hneeds_user/common/models/address_model.dart';
import 'package:hneeds_user/common/models/config_model.dart';
import 'package:hneeds_user/features/address/providers/address_provider.dart';
import 'package:hneeds_user/features/address/providers/location_provider.dart';
import 'package:hneeds_user/features/address/widgets/address_button_widget.dart';
import 'package:hneeds_user/features/address/widgets/address_details_widget.dart';
import 'package:hneeds_user/features/address/widgets/address_web_widget.dart';
import 'package:hneeds_user/features/address/widgets/address_map_widget.dart';
import 'package:hneeds_user/features/address/widgets/without_map_widget.dart';
import 'package:hneeds_user/features/profile/providers/profile_provider.dart';
import 'package:hneeds_user/features/splash/providers/splash_provider.dart';
import 'package:hneeds_user/helper/phone_number_checker_helper.dart';
import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/localization/language_constrants.dart';
import 'package:hneeds_user/common/widgets/custom_app_bar_widget.dart';
import 'package:hneeds_user/common/widgets/custom_web_title_widget.dart';
import 'package:hneeds_user/common/widgets/footer_web_widget.dart';
import 'package:hneeds_user/common/enums/footer_type_enum.dart';
import 'package:hneeds_user/utill/dimensions.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isUpdateEnable;
  final bool fromCheckout;
  final AddressModel? address;

  const AddNewAddressScreen({
    super.key,
    this.isUpdateEnable = true,
    this.address,
    this.fromCheckout = false,
  });

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  // Controllers
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  // Focus nodes
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _stateNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();

  // Selected city/state/country
  int? _cityId;
  int? _stateId;
  int? _countryId;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final userModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;

    // Set default country code
    addressProvider.setCountryCode(
      CountryCode.fromCountryCode(splashProvider.configModel!.countryCode!).dialCode ?? '',
    );

    // Reset picked location
    locationProvider.setPickedAddressLatLon(null, null, isUpdate: false);

    // Initialize address types
    await addressProvider.initializeAllAddressType(context: context);
    addressProvider.setAddressStatusMessage = '';
    addressProvider.setErrorMessage = '';

    if (widget.isUpdateEnable && widget.address != null) {
      // Google Map: update marker position
      if ((splashProvider.configModel?.googleMapStatus ?? false) &&
          (widget.address!.latitude?.isNotEmpty ?? false) &&
          (widget.address!.longitude?.isNotEmpty ?? false)) {
        locationProvider.updatePosition(
          CameraPosition(
            target: LatLng(
              double.parse(widget.address!.latitude!),
              double.parse(widget.address!.longitude!),
            ),
          ),
          true,
          widget.address!.address,
          false,
        );
        locationProvider.setPickedAddressLatLon(widget.address!.latitude, widget.address!.longitude);
      }

      // Populate form fields
      _contactPersonNameController.text = widget.address!.contactPersonName ?? '';
      _contactPersonNumberController.text = PhoneNumberCheckerHelper.getPhoneNumber(
        '+${widget.address!.contactPersonNumber?.replaceAll('++', '+')}',
        addressProvider.countryCode ?? '',
      ) ?? '';
      _streetNumberController.text = widget.address!.streetNumber ?? '';
      _houseNumberController.text = widget.address!.houseNumber ?? '';
      _floorNumberController.text = widget.address!.floorNumber ?? '';
      _pincodeController.text = widget.address!.pincode ?? '';
      _cityId = widget.address!.cityId;
      _stateId = widget.address!.stateId;
      _countryId = widget.address!.countryId;

      // Set address type
      if (widget.address!.addressType == 'Home') addressProvider.updateAddressIndex(0, false);
      else if (widget.address!.addressType == 'Workplace') addressProvider.updateAddressIndex(1, false);
      else addressProvider.updateAddressIndex(2, false);
    } else {
      // New address: use user info
      _contactPersonNameController.text = '${userModel?.fName ?? ''} ${userModel?.lName ?? ''}';
      _contactPersonNumberController.text = PhoneNumberCheckerHelper.getPhoneNumber(
        userModel?.phone ?? '',
        addressProvider.countryCode ?? '',
      ) ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.read<AddressProvider>();
    final locationProvider = context.read<LocationProvider>();
    final splashProvider = context.read<SplashProvider>();

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.isUpdateEnable
            ? getTranslated('update_address', context)
            : getTranslated('add_new_address', context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Center(
                      child: SizedBox(
                        width: Dimensions.webScreenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWebTitleWidget(
                              title: getTranslated(
                                  widget.isUpdateEnable ? 'update_address' : 'add_new_address',
                                  context),
                            ),

                            // Mobile Google Map
                            if (!ResponsiveHelper.isDesktop(context) &&
                                (splashProvider.configModel?.googleMapStatus ?? false))
                              Selector<LocationProvider, String?>(
                                selector: (context, provider) => provider.pickedAddressLatitude,
                                builder: (context, lat, child) {
                                  if (widget.address != null) {
                                    if (locationProvider.pickedAddressLatitude == null ||
                                        locationProvider.pickedAddressLongitude == null)
                                      return const WithoutMapWidget();
                                    return AddressMapWidget(
                                      isUpdateEnable: widget.isUpdateEnable,
                                      address: widget.address,
                                      fromCheckout: widget.fromCheckout,
                                      locationTextController: _locationTextController,
                                    );
                                  }
                                  return AddressMapWidget(
                                    isUpdateEnable: widget.isUpdateEnable,
                                    address: widget.address,
                                    fromCheckout: widget.fromCheckout,
                                    locationTextController: _locationTextController,
                                  );
                                },
                              ),

                            // Details Form - Mobile
                            if (!ResponsiveHelper.isDesktop(context))
                              AddressDetailsWidget(
                                contactPersonNameController: _contactPersonNameController,
                                contactPersonNumberController: _contactPersonNumberController,
                                addressNode: _addressNode,
                                nameNode: _nameNode,
                                numberNode: _numberNode,
                                fromCheckout: widget.fromCheckout,
                                address: widget.address,
                                isUpdateEnable: widget.isUpdateEnable,
                                locationTextController: _locationTextController,
                                streetNumberController: _streetNumberController,
                                houseNumberController: _houseNumberController,
                                houseNode: _houseNode,
                                stateNode: _stateNode,
                                florNumberController: _floorNumberController,
                                florNode: _floorNode,
                                pincodeController: _pincodeController,
                                cityId: _cityId,
                                stateId: _stateId,
                                countryId: _countryId,
                              ),

                            // Details Form - Web
                            if (ResponsiveHelper.isDesktop(context))
                              AddressWebWidget(
                                contactPersonNameController: _contactPersonNameController,
                                contactPersonNumberController: _contactPersonNumberController,
                                addressNode: _addressNode,
                                nameNode: _nameNode,
                                numberNode: _numberNode,
                                fromCheckout: widget.fromCheckout,
                                address: widget.address,
                                isUpdateEnable: widget.isUpdateEnable,
                                locationTextController: _locationTextController,
                                streetNumberController: _streetNumberController,
                                houseNumberController: _houseNumberController,
                                houseNode: _houseNode,
                                stateNode: _stateNode,
                                floorNumberController: _floorNumberController,
                                floorNode: _floorNode,
                                pincodeController: _pincodeController,
                                cityId: _cityId,
                                stateId: _stateId,
                                countryId: _countryId,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const FooterWebWidget(footerType: FooterType.nonSliver),
                ],
              ),
            ),
          ),

          // Mobile Submit Button
          if (!ResponsiveHelper.isDesktop(context))
            AddressButtonWidget(
              isUpdateEnable: widget.isUpdateEnable,
              fromCheckout: widget.fromCheckout,
              contactPersonNumberController: _contactPersonNumberController,
              contactPersonNameController: _contactPersonNameController,
              streetNumberController: _streetNumberController,
              houseNumberController: _houseNumberController,
              floorNumberController: _floorNumberController,
              address: widget.address,
              location: _locationTextController.text,
              countryCode: addressProvider.countryCode ?? '',
              cityId: _cityId,
              stateId: _stateId,
              countryId: _countryId,
              pincodeController: _pincodeController,
            ),
        ],
      ),
    );
  }
}
