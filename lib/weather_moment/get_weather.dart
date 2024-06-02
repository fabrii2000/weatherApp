import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meteo_app/weather_moment/city_model.dart';
import 'package:meteo_app/weather_moment/weather_model.dart';

const String apiKey = 'ab101f9adb21c7eee68f5ccc36427e5a';

class WeatherClient {
  Dio dio = Dio();

  Future<WeatherModel?> getData(
      {required String nameCity, num limit = 1}) async {
    String url =
        "http://api.openweathermap.org/geo/1.0/direct?q=${nameCity},&limit=${limit}&appid=${apiKey}";
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        CityModel? cityResponse = CityModel.fromJson(response.data[0]);
        return await _getWeather(cityModel: cityResponse);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<WeatherModel?> _getWeather({required CityModel cityModel}) async {
    String url2 =
        "https://api.openweathermap.org/data/2.5/weather?lat=${cityModel.lat ?? ""}&lon=${cityModel.lon ?? ""}&appid=$apiKey";
    if (kDebugMode) {
      print(url2);
    }
    try {
      final response = await dio.get(url2);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        return WeatherModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Future<List<CityModel>> searchCities(String query) async {
  //   String url =
  //       "http://api.openweathermap.org/geo/1.0/direct?q=${query}&limit=5&appid=${apiKey}";
  //   try {
  //     final response = await dio.get(url);
  //     if (response.statusCode == 200) {
  //       List<CityModel> cities = (response.data as List)
  //           .map((item) => CityModel.fromJson(item))
  //           .toList();
  //       return cities;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return [];
  //   }
  // }
}
