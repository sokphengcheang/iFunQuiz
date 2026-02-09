import 'package:ifunquiz/ip_package/country_name_iso_3166_alpha_2.dart';

/// Response model for country API
class CountryResponse {
  CountryResponse({required this.countryCode, required this.ip}) : country = countryList[countryCode] ?? countryCode;

  factory CountryResponse.fromJson(Map<String, dynamic> json) =>
      CountryResponse(countryCode: json['country'] as String, ip: json['ip'] as String);

  final String country;
  final String countryCode;
  final String ip;

  @override
  String toString() {
    return 'CountryResponse(country: $country, countryCode: $countryCode, ip: $ip)';
  }
}
