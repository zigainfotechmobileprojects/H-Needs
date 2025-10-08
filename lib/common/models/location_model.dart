// class LocationModel {
//   int? id;
//   String? name;
//   List<States>? states;

//   LocationModel({this.id, this.name, this.states});

//   LocationModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     if (json['states'] != null) {
//       states = <States>[];
//       json['states'].forEach((v) {
//         states!.add(States.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     if (states != null) {
//       data['states'] = states!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class States {
//   int? id;
//   String? name;
//   int? countryId;
//   List<Cities>? cities;

//   States({this.id, this.name, this.countryId, this.cities});

//   States.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     countryId = json['country_id'];
//     if (json['cities'] != null) {
//       cities = <Cities>[];
//       json['cities'].forEach((v) {
//         cities!.add(Cities.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['country_id'] = countryId;
//     if (cities != null) {
//       data['cities'] = cities!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Cities {
//   int? id;
//   String? name;
//   int? stateId;

//   Cities({this.id, this.name, this.stateId});

//   Cities.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     stateId = json['state_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['state_id'] = stateId;
//     return data;
//   }
// }


// class CitySearchModel {
//   final int cityId;
//   final String cityName;
//   final int stateId;
//   final String stateName;
//   final int countryId;
//   final String countryName;

//   CitySearchModel({
//     required this.cityId,
//     required this.cityName,
//     required this.stateId,
//     required this.stateName,
//     required this.countryId,
//     required this.countryName,
//   });
// }



// -------------------- Flat City Model --------------------
class CityModel {
  final int cityId;
  final String cityName;
  final int stateId;
  final String stateName;
  final int countryId;
  final String countryName;

  CityModel({
    required this.cityId,
    required this.cityName,
    required this.stateId,
    required this.stateName,
    required this.countryId,
    required this.countryName,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cityId: json['city_id'] ?? 0,
      cityName: json['city_name'] ?? '',
      stateId: json['state_id'] ?? 0,
      stateName: json['state_name'] ?? '',
      countryId: json['country_id'] ?? 0,
      countryName: json['country_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city_id': cityId,
      'city_name': cityName,
      'state_id': stateId,
      'state_name': stateName,
      'country_id': countryId,
      'country_name': countryName,
    };
  }
}

// -------------------- Optional: Response Wrapper --------------------
class CityResponse {
  final String message;
  final List<CityModel> cities;

  CityResponse({
    required this.message,
    required this.cities,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    var cityList = <CityModel>[];
    if (json['cities'] != null) {
      cityList = List<Map<String, dynamic>>.from(json['cities'])
          .map((c) => CityModel.fromJson(c))
          .toList();
    }
    return CityResponse(
      message: json['message'] ?? '',
      cities: cityList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'cities': cities.map((c) => c.toJson()).toList(),
    };
  }
}
