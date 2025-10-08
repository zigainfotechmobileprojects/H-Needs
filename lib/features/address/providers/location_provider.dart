import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hneeds_user/features/address/domain/reposotories/location_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hneeds_user/common/models/address_model.dart';
import 'package:hneeds_user/common/models/api_response_model.dart';
import 'package:hneeds_user/common/models/location_model.dart'; // Import for Country/State/City models
import 'package:hneeds_user/common/models/response_model.dart';
import 'package:hneeds_user/helper/api_checker_helper.dart';
import 'package:hneeds_user/localization/language_constrants.dart';
import 'package:hneeds_user/main.dart';

class LocationProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final LocationRepo locationRepo;

  LocationProvider(
      {required this.sharedPreferences, required this.locationRepo});

  // --- STATE FOR GEOLOCATION AND MAPS ---
  bool _isLoading = false;
  Position _currentPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 1,
      headingAccuracy: 1);
  Position _pickPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 1,
      headingAccuracy: 1);
  String? _address;
  String? _pickAddress = '';
  bool _willUpdatePosition = true;
  bool _changeAddress = true;
  String? _pickedAddressLatitude;
  String? _pickedAddressLongitude;
  List<AddressModel>? _addressList;

  // --- STATE FOR COUNTRY/STATE/CITY DROPDOWNS ---
  bool _isLocationDataLoading = false;
  List<CityModel> _flatCityList = [];
  String? _selectedCountryName;
  String? _selectedStateName;
  int? _selectedCountryId;
  int? _selectedStateId;
  int? _selectedCityId;

  // --- GETTERS ---
  // Getters for Geolocation and Maps
  bool get isLoading => _isLoading;
  Position get currentPosition => _currentPosition;
  Position get pickPosition => _pickPosition;
  String? get address => _address;
  String? get pickAddress => _pickAddress;
  String? get pickedAddressLatitude => _pickedAddressLatitude;
  String? get pickedAddressLongitude => _pickedAddressLongitude;

  // Getters for Dropdowns
  bool get isLocationDataLoading => _isLocationDataLoading;
  List<CityModel> get flatCityList => _flatCityList;
  String? get selectedCountryName => _selectedCountryName;
  String? get selectedStateName => _selectedStateName;
  int? get selectedCountryId => _selectedCountryId;
  int? get selectedStateId => _selectedStateId;
  int? get selectedCityId => _selectedCityId;

  // --- SETTERS ---
  set setAddress(String? addressValue) => _address = addressValue;

  // --- METHODS FOR COUNTRY/STATE/CITY DROPDOWNS ---
// ... inside your LocationProvider class

  // ... inside your LocationProvider class

Future<void> getAllLocationData({bool notify = true}) async {
    _isLocationDataLoading = true;
    if (notify) notifyListeners();

    try {
      final ApiResponseModel apiResponse = await locationRepo.getAllLocationData();
      if (apiResponse.response?.statusCode == 200) {
        final List<dynamic> citiesData = apiResponse.response!.data['cities'] ?? [];
        _flatCityList = citiesData.map((c) => CityModel.fromJson(c)).toList();
        debugPrint('✅ Flat city list length: ${_flatCityList.length}');
      } else {
        _flatCityList = [];
        debugPrint('❌ Failed to fetch cities');
      }
    } catch (e) {
      _flatCityList = [];
      debugPrint('❌ Exception: $e');
    }

    _isLocationDataLoading = false;
    if (notify) notifyListeners();
  }

  void selectCityFromSearch(CityModel? city) {
    if (city != null) {
      _selectedCityId = city.cityId;
      _selectedStateId = city.stateId;
      _selectedCountryId = city.countryId;
      _selectedStateName = city.stateName;
      _selectedCountryName = city.countryName;
    } else {
      _selectedCityId = null;
      _selectedStateId = null;
      _selectedCountryId = null;
      _selectedStateName = null;
      _selectedCountryName = null;
    }
    notifyListeners();
  }

  void setInitialLocation(int? cityId) {
    if (cityId != null && _flatCityList.isNotEmpty) {
      try {
        final initialCity = _flatCityList.firstWhere((c) => c.cityId == cityId);
        selectCityFromSearch(initialCity);
      } catch (_) {}
    }
  }

  // /// Updates the list of states based on the selected country ID.
  // void updateStateList(int? countryId) {
  //   _selectedCountryId = countryId;
  //   _selectedStateId = null;
  //   _selectedCityId = null;
  //   _stateList = null;
  //   _cityList = null;

  //   if (countryId != null && _locationList != null) {
  //     try {
  //       _stateList = _locationList!.firstWhere((country) => country.id == countryId).states;
  //     } catch (e) {
  //       _stateList = []; // Handle case where country might not be found
  //     }
  //   }
  //   notifyListeners();
  // }

  // /// Updates the list of cities based on the selected state ID.
  // void updateCityList(int? stateId) {
  //   _selectedStateId = stateId;
  //   _selectedCityId = null;
  //   _cityList = null;

  //   if (stateId != null && _stateList != null) {
  //     try {
  //       _cityList = _stateList!.firstWhere((state) => state.id == stateId).cities;
  //     } catch (e) {
  //       _cityList = []; // Handle case where state might not be found
  //     }
  //   }
  //   notifyListeners();
  // }

  // /// Sets the final selected city ID.
  // void setSelectedCityId(int? cityId) {
  //   _selectedCityId = cityId;
  //   notifyListeners();
  // }

  // /// Clears all dropdown selections and lists.
  // void clearLocationSelections() {
  //   _locationList = null;
  //   _stateList = null;
  //   _cityList = null;
  //   _selectedCountryId = null;
  //   _selectedStateId = null;
  //   _selectedCityId = null;
  //   notifyListeners();
  // }

  // --- METHODS FOR GEOLOCATION AND MAPS ---

  void getCurrentLocation(BuildContext context, bool fromAddress,
      {GoogleMapController? mapController}) async {
    _isLoading = true;
    notifyListeners();
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      position = Position(
          latitude: 0,
          longitude: 0,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 1,
          heading: 1,
          speed: 1,
          speedAccuracy: 1,
          altitudeAccuracy: 1,
          headingAccuracy: 1);
    }

    if (fromAddress) {
      _currentPosition = position;
    } else {
      _pickPosition = position;
    }

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 16),
      ));
    }
    if (fromAddress) {
      _address = await getAddressFromGeocode(
          LatLng(position.latitude, position.longitude));
    }
    _isLoading = false;
    notifyListeners();
  }

  void setPickedAddressLatLon(String? lat, String? lon,
      {bool isUpdate = true}) {
    _pickedAddressLatitude = lat;
    _pickedAddressLongitude = lon;
    if (isUpdate) {
      notifyListeners();
    }
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String? address;
    ApiResponseModel? response =
        await locationRepo.getAddressFromGeocode(latLng);
    if (response.response?.statusCode == 200 &&
        response.response?.data['status'] == 'OK') {
      address =
          response.response?.data['results'][0]['formatted_address'].toString();
    } else {
      ApiCheckerHelper.checkApi(response);
    }
    return address ?? getTranslated('unknown_location_found', Get.context!);
  }

  void updatePosition(CameraPosition? cameraPosition, bool fromAddress,
      String? address, bool forceNotify) async {
    if (_willUpdatePosition || forceNotify) {
      _isLoading = true;
      notifyListeners();
      try {
        Position position = Position(
          latitude:
              double.parse(cameraPosition!.target.latitude.toStringAsFixed(7)),
          longitude:
              double.parse(cameraPosition.target.longitude.toStringAsFixed(7)),
          timestamp: DateTime.now(),
          heading: 1,
          accuracy: 1,
          altitude: 1,
          speedAccuracy: 1,
          speed: 1,
          altitudeAccuracy: 1,
          headingAccuracy: 1,
        );

        if (fromAddress) {
          _currentPosition = position;
        } else {
          _pickPosition = position;
        }

        if (_changeAddress) {
          String addressFromGeocode = await getAddressFromGeocode(LatLng(
              cameraPosition.target.latitude, cameraPosition.target.longitude));
          if (fromAddress) {
            _address = addressFromGeocode;
          } else {
            _pickAddress = addressFromGeocode;
          }
        } else {
          _changeAddress = true;
        }
      } catch (e) {
        debugPrint('error ==> $e');
      }
      _isLoading = false;
      notifyListeners();
    } else {
      _willUpdatePosition = true;
    }
  }

  void setLocationData(bool isUpdate) {
    _currentPosition = _pickPosition;
    _address = _pickAddress;
    _willUpdatePosition = false;
    if (isUpdate) {
      notifyListeners();
    }
  }

  void setPickData() {
    _pickPosition = _currentPosition;
    _pickAddress = _address;
  }

  void setLocation(String? placeID, String? address,
      GoogleMapController? mapController) async {
    _isLoading = true;
    notifyListeners();

    ApiResponseModel response = await locationRepo.getPlaceDetails(placeID);
    PlacesDetailsResponse detail =
        PlacesDetailsResponse.fromJson(response.response?.data);

    _pickPosition = Position(
      longitude: detail.result.geometry!.location.lng,
      latitude: detail.result.geometry!.location.lat,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 1,
      headingAccuracy: 1,
    );
    _pickAddress = address;
    _address = address;
    _changeAddress = false;

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng,
          ),
          zoom: 16)));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<ResponseModel?> initAddressList() async {
    ResponseModel? responseModel;
    _addressList = null;
    ApiResponseModel apiResponse = await locationRepo.getAllAddress();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _addressList = [];
      apiResponse.response!.data.forEach(
          (address) => _addressList!.add(AddressModel.fromJson(address)));
      responseModel = ResponseModel(true, 'successful');
    } else {
      _addressList = [];
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
    return responseModel;
  }
}
