import 'package:flutter/material.dart';
import 'package:hneeds_user/common/models/address_model.dart';
import 'package:hneeds_user/common/models/config_model.dart';
import 'package:hneeds_user/features/address/providers/address_provider.dart';
import 'package:hneeds_user/features/address/providers/location_provider.dart';
import 'package:hneeds_user/features/address/widgets/address_button_widget.dart';
import 'package:hneeds_user/features/address/widgets/address_details_web_widget.dart';
import 'package:hneeds_user/features/address/widgets/address_map_web_widget.dart';
import 'package:hneeds_user/features/address/widgets/without_map_widget.dart';
import 'package:hneeds_user/features/splash/providers/splash_provider.dart';
import 'package:provider/provider.dart';

class AddressWebWidget extends StatefulWidget {
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final TextEditingController locationTextController;
  final TextEditingController streetNumberController;
  final TextEditingController houseNumberController;
  final TextEditingController floorNumberController;
  final TextEditingController pincodeController;

  final FocusNode addressNode;
  final FocusNode nameNode;
  final FocusNode numberNode;
  final FocusNode stateNode;
  final FocusNode houseNode;
  final FocusNode floorNode;

  final bool isUpdateEnable;
  final bool fromCheckout;
  final AddressModel? address;

  final int? cityId;
  final int? stateId;
  final int? countryId;

  const AddressWebWidget({
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
    required this.floorNumberController,
    required this.pincodeController,
    required this.stateNode,
    required this.houseNode,
    required this.floorNode,
    this.cityId,
    this.stateId,
    this.countryId,
  });

  @override
  State<AddressWebWidget> createState() => _AddressWebWidgetState();
}

class _AddressWebWidgetState extends State<AddressWebWidget> {
  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = context.read<SplashProvider>().configModel!;
    final Size size = MediaQuery.of(context).size;
    final LocationProvider locationProvider = context.read<LocationProvider>();
    final AddressProvider addressProvider = context.read<AddressProvider>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: !(configModel.googleMapStatus ?? false)
            ? size.width * 0.06
            : 0.0,
        vertical: !(configModel.googleMapStatus ?? false)
            ? size.height * 0.02
            : 0.0,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: !(configModel.googleMapStatus ?? false)
            ? size.width * 0.08
            : 0.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Address details form
              Expanded(
                flex: 5,
                child: AddressDetailsWebWidget(
                  contactPersonNameController: widget.contactPersonNameController,
                  contactPersonNumberController: widget.contactPersonNumberController,
                  addressNode: widget.addressNode,
                  nameNode: widget.nameNode,
                  numberNode: widget.numberNode,
                  isUpdateEnable: widget.isUpdateEnable,
                  address: widget.address,
                  fromCheckout: widget.fromCheckout,
                  locationTextController: widget.locationTextController,
                  streetNumberController: widget.streetNumberController,
                  houseNumberController: widget.houseNumberController,
                  houseNode: widget.houseNode,
                  stateNode: widget.stateNode,
                  florNumberController: widget.floorNumberController,
                  florNode: widget.floorNode,
                  // pincodeController: widget.pincodeController,
                ),
              ),

              // Right side: Map + Button (if Google Map enabled)
              if (configModel.googleMapStatus ?? false) ...[
                Selector<LocationProvider, String?>(
                  selector: (context, provider) => provider.pickedAddressLatitude,
                  builder: (context, lat, child) {
                    return Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          if (widget.address != null) ...[
                            if (locationProvider.pickedAddressLatitude == null ||
                                locationProvider.pickedAddressLongitude == null) ...[
                              const WithoutMapWidget(),
                            ],
                            if (locationProvider.pickedAddressLatitude != null &&
                                locationProvider.pickedAddressLongitude != null) ...[
                              AddressMapWebWidget(
                                isUpdateEnable: widget.isUpdateEnable,
                                address: widget.address,
                                fromCheckout: widget.fromCheckout,
                                locationTextController: widget.locationTextController,
                              ),
                            ]
                          ] else ...[
                            AddressMapWebWidget(
                              isUpdateEnable: widget.isUpdateEnable,
                              address: widget.address,
                              fromCheckout: widget.fromCheckout,
                              locationTextController: widget.locationTextController,
                            ),
                          ],
                          const SizedBox(height: 16),

                          // Save/Update button
                          Row(
                            children: [
                              Expanded(child: Container()),
                              Expanded(
                                child: AddressButtonWidget(
                                  isUpdateEnable: widget.isUpdateEnable,
                                  fromCheckout: widget.fromCheckout,
                                  contactPersonNumberController: widget.contactPersonNumberController,
                                  contactPersonNameController: widget.contactPersonNameController,
                                  address: widget.address,
                                  location: widget.locationTextController.text,
                                  streetNumberController: widget.streetNumberController,
                                  houseNumberController: widget.houseNumberController,
                                  floorNumberController: widget.floorNumberController,
                                  countryCode: addressProvider.countryCode ?? '',
                                  pincodeController: widget.pincodeController,
                                  cityId: widget.cityId,
                                  stateId: widget.stateId,
                                  countryId: widget.countryId,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),

          // Button row if Google Map is not enabled
          if (!(configModel.googleMapStatus ?? false)) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Container()),
                Expanded(
                  child: AddressButtonWidget(
                    isUpdateEnable: widget.isUpdateEnable,
                    fromCheckout: widget.fromCheckout,
                    contactPersonNumberController: widget.contactPersonNumberController,
                    contactPersonNameController: widget.contactPersonNameController,
                    address: widget.address,
                    location: widget.locationTextController.text,
                    streetNumberController: widget.streetNumberController,
                    houseNumberController: widget.houseNumberController,
                    floorNumberController: widget.floorNumberController,
                    countryCode: addressProvider.countryCode ?? '',
                    pincodeController: widget.pincodeController,
                    cityId: widget.cityId,
                    stateId: widget.stateId,
                    countryId: widget.countryId,
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
