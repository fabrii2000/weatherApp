import 'package:flutter/material.dart';
import 'package:meteo_app/pages/drawer_code.dart';
import 'package:meteo_app/weather_moment/get_icon.dart';
import 'package:meteo_app/weather_three_hour/get_three_hour_data.dart';
import 'package:weather_icons/weather_icons.dart';

import '../city_suggestion.dart';
import '../global_variable.dart' as global;
import '../weather_three_hour/weather_model_three_hour.dart';
import 'app_bar_code.dart';

class DetailsWeather extends StatefulWidget {
  final String cityName;
  DetailsWeather({super.key, required this.cityName});

  @override
  State<DetailsWeather> createState() => _DetailsWeatherState();
}

class _DetailsWeatherState extends State<DetailsWeather> {
  WeatherModelThreeHour? weatherDataThreeHour;
  ThreeHourWeatherClient? weatherClient = ThreeHourWeatherClient();
  Map<TimeOfDay?, WeatherList?> timeWeather = {};
  Map<DateTime?, Map<TimeOfDay?, WeatherList?>>? hourDateWeatherMap = {};
  List<WeatherList>? weatherAllList = [];
  Set<DateTime> dateSet = {};
  List<DateTime?> dateList = [];
  List<TimeOfDay?>? hourList = [];
  int _dateIndex = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      weatherDataThreeHour =
          await weatherClient?.getDataThreeHour(nameCity: widget.cityName);
      List<WeatherList>? weatherAllList =
          weatherDataThreeHour?.weatherList ?? [];
      DateTime dateTime;
      DateTime date;
      TimeOfDay time;
      for (WeatherList weatherThreeHour in weatherAllList) {
        dateTime = DateTime.parse(weatherThreeHour.dtTxt!);
        date = DateTime.parse(weatherThreeHour.dtTxt!.split(" ")[0]);
        time = TimeOfDay.fromDateTime(dateTime);
        dateSet.add(date);

        if (hourDateWeatherMap?[date] == null) {
          Map<TimeOfDay?, WeatherList?> newTimeWeather = {};
          newTimeWeather[time] = weatherThreeHour;
          hourDateWeatherMap?[date] = newTimeWeather;
        } else {
          hourDateWeatherMap?[date]?[time] = weatherThreeHour;
        }
      }
      print(
          "la nostra mappa finale è:$hourDateWeatherMap, ci dovrebbero essere le date con tutti i tampiWeather");
      dateList = dateSet.toList();

      dateList.sort((DateTime? a, DateTime? b) {
        if (a == null && b == null) return 0;
        if (a == null) return 1;
        if (b == null) return -1;
        return a.compareTo(b);
      });
      hourList = hourDateWeatherMap?[dateList[_dateIndex]]?.keys.toList();
      hourList?.sort((TimeOfDay? a, TimeOfDay? b) {
        if (a == null && b == null) return 0;
        if (a == null) return 1;
        if (b == null) return -1;
        return a.hour.compareTo(b.hour);
      });
      setState(() {});
    });
  }

  void ChangeDate({required index}) {
    setState(() {
      _dateIndex = index;
      hourList = hourDateWeatherMap?[dateList[index]]?.keys.toList();
      hourList?.sort((TimeOfDay? a, TimeOfDay? b) {
        if (a == null && b == null) return 0;
        if (a == null) return 1;
        if (b == null) return -1;
        return a.hour.compareTo(b.hour);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCode(title: widget.cityName),
        backgroundColor: Color.fromARGB(255, 0, 170, 255),
        drawer: const DrawerCode(),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(
              height: global.height(context) * 0.01,
            ),
            Row(children: <Widget>[
              SizedBox(
                height: global.height(context) * 0.05,
                width: global.width(context),
                child: ListView.builder(
                  itemCount: dateList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    String date =
                        dateList[index].toString().split(" ")[0].split("-")[2];

                    return SizedBox(
                      width: global.width(context) * 0.38,
                      height: global.height(context) * 0.01,
                      child: InkWell(
                        onTap: () => ChangeDate(index: index),
                        enableFeedback: true,
                        child: Card(
                            color: _dateIndex == index
                                ? Color.fromARGB(255, 0, 135, 255)
                                : Color.fromARGB(255, 0, 100, 255),
                            child: Center(
                              child: Text(
                                "${daysOfWeek[dateList[index]!.weekday - 1]} ${date}",
                              ),
                            )),
                      ),
                    );
                  },
                ),
              ),
            ]),
            SizedBox(
              height: global.height(context) * 0.01,
            ),
            SizedBox(
              height: global.height(context) * 0.81,
              child: ListView.builder(
                itemCount: hourList?.length,
                itemBuilder: (context, index) {
                  String? description = hourDateWeatherMap?.length == 0
                      ? " "
                      : hourDateWeatherMap![dateList[_dateIndex]]
                              ?[hourList?[index]]
                          ?.weather
                          ?.first
                          .description;
                  String? time =
                      hourList?[index].toString().split("(")[1].split(")")[0];
                  String? iconCode = hourDateWeatherMap?.length == null
                      ? ""
                      : hourDateWeatherMap![dateList[_dateIndex]]
                              ?[hourList?[index]]
                          ?.weather
                          ?.first
                          .icon;
                  String? temp =
                      '${hourDateWeatherMap?.length == null && hourDateWeatherMap![dateList[_dateIndex]]?[hourList?[index]]?.main?.temp!.round() == 0 ? "" : hourDateWeatherMap![dateList[_dateIndex]]![hourList?[index]]!.main!.temp!.round() - 273}°C';

                  return SizedBox(
                    height: global.height(context) * 0.15,
                    child: Card(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: global.width(context) * 0.035,
                            ),
                            Text(
                              "$time",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: global.height(context) * 0.033),
                            ),
                            SizedBox(width: global.width(context) * 0.03),
                            BoxedIcon(getIcon(iconCode: iconCode),
                                color: Color.fromARGB(255, 0, 0, 255),
                                size: global.width(context) * 0.095),
                            SizedBox(
                              width: global.width(context) * 0.03,
                            ),
                            Text(
                              "${temp}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: global.height(context) * 0.033),
                            ),
                            SizedBox(
                              width: global.width(context) * 0.03,
                            ),
                            Text("${description}"),
                            SizedBox(
                              width: global.width(context) * 0.035,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: global.height(context) * 0.01,
            ),
            SizedBox(height: global.height(context) * 0.01),
          ]),
        ));
  }
}
