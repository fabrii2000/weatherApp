import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meteo_app/weather_models/city_model.dart';
import 'package:meteo_app/weather_models/weather_model_three_hour.dart';

const String apiKey = 'ab101f9adb21c7eee68f5ccc36427e5a';

class ThreeHourWeatherClient {
  Dio dio = Dio();
  Future<WeatherModelThreeHour?> getDataThreeHour(
      {required String nameCity, num limit = 1}) async {
    String url =
        'http://api.openweathermap.org/geo/1.0/direct?q=$nameCity,&limit=$limit&appid=$apiKey';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        CityModel? cityResponse = CityModel.fromJson(response.data[0]);

        return await getThreeHourData(cityModel: cityResponse);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<WeatherModelThreeHour?> getThreeHourData(
      {required CityModel cityModel}) async {
    String url3 =
        "http://api.openweathermap.org/data/2.5/forecast?lat=${cityModel.lat ?? ""}&lon=${cityModel.lon ?? ""}&appid=$apiKey";
    print(url3);
    try {
      final response = await dio.get(url3);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        return WeatherModelThreeHour.fromJson(response.data);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
