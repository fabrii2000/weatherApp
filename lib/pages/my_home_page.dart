import 'package:filter_list/filter_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meteo_app/api_calls/get_weather.dart';
import 'package:meteo_app/utils/AppColors.dart';
import 'package:meteo_app/utils/get_color.dart';
import 'package:meteo_app/weather_models/weather_model.dart';
import 'package:meteo_app/widgets/text_field_widget.dart';
import 'package:weather_icons/weather_icons.dart';

import '../utils/filter_const.dart';
import '../utils/get_icon.dart';
import '../utils/global_variable.dart' as global;
import '../widgets/app_bar_widget.dart';
import '../widgets/drawer_widget.dart';
import 'details_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController cityController = TextEditingController();
  // List<String?>? _suggestedCities = [];
  bool disableButton = false;
  List<String> cityList = [
    'Naples',
    'Rome',
    'London',
    'New York',
    'Moscow',
    'Florence',
    'Bari',
    'Paris'
  ];

  WeatherModel? weatherData;
  WeatherClient weatherClient = WeatherClient();
  Map<String?, WeatherModel?> cityWeatherMap = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      for (String city in cityList) {
        weatherData = await weatherClient.getData(nameCity: city);

        cityWeatherMap[city] = weatherData;
      }
      setState(() {});
      if (kDebugMode) {
        print(cityWeatherMap);
      }
    });
  }

  void openFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: FilterListWidget<Filter>(
              listData: filterList,
              selectedListData: selectedFilterList,
              onApplyButtonClick: (list) {
                setState(() {
                  if (list != null && list.isNotEmpty) {
                    selectedFilterList = [list.last];
                  }
                  applyFilters();
                });
                Navigator.pop(context);
              },
              choiceChipLabel: (item) => item!.filterType,
              validateSelectedItem: (list, val) => list!.contains(val),
              onItemSearch: (item, query) {
                return item.filterType!
                    .toLowerCase()
                    .contains(query.toLowerCase());
              },
              enableOnlySingleSelection: true,
            ),
          ),
        );
      },
    );
  }

  void applyFilters() {
    setState(() {
      if (selectedFilterList.isNotEmpty) {
        switch (selectedFilterList.last.filterType) {
          case "A-Z":
            cityList.sort();
            break;
          case "Temp ↓":
            cityList.sort((a, b) {
              double tempA = cityWeatherMap[a]?.main?.temp ?? double.infinity;
              double tempB = cityWeatherMap[b]?.main?.temp ?? double.infinity;
              return tempB.compareTo(tempA);
            });
            break;
          case "Temp ↑":
            cityList.sort((a, b) {
              double tempA = cityWeatherMap[a]?.main?.temp ?? double.infinity;
              double tempB = cityWeatherMap[b]?.main?.temp ?? double.infinity;
              return tempA.compareTo(tempB);
            });
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  Future<void> _addCity() async {
    if (disableButton) return;
    setState(() {
      disableButton = true;
    });

    String cityName = cityController.text.trim().toLowerCase();
    if (cityName.isEmpty) {
      setState(() {
        disableButton = false;
      });
      return;
    }
    cityName = cityName[0].toUpperCase() + cityName.substring(1);
    print(cityName);

    var weatherData = await weatherClient.getData(nameCity: cityName);
    setState(() {
      if (weatherData != null) {
        int existingIndex = cityList.indexOf(cityName);
        if (existingIndex != -1 && existingIndex != 0) {
          cityList.removeAt(existingIndex);
        }
        if (existingIndex != 0) {
          cityList.insert(0, cityName);
        }
        cityWeatherMap[cityName] = weatherData;
        cityController.clear();
        disableButton = false;
      }
      disableButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String titleHomePage = "WEATHER";
    return Scaffold(
      appBar: AppBarWidget(title: titleHomePage),
      drawer: const DrawerWidget(),
      backgroundColor: AppColors.backGroundColorHome,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 0.04 * global.height(context),
              child: Row(children: <Widget>[
                SizedBox(
                  width: global.width(context) * 0.39,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.012 * global.height(context)),
                  child: Text('LOCATION',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 0.024 * global.height(context))),
                ),
                SizedBox(width: global.width(context) * 0.18),
                Transform(
                  transform: Matrix4(
                      1,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                      -global.width(context) * 0.005,
                      global.width(context) * 0.017,
                      0,
                      1),
                  child: FittedBox(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            AppColors.colorFilter),
                        enableFeedback: true,
                      ),
                      onPressed: openFilterDialog,
                      child: Icon(
                        size: global.width(context) * 0.08,
                        Icons.filter_list,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
                padding: EdgeInsets.all(global.width(context) * 0.0357),
                child: TextFieldWidget(
                  controller: cityController,
                )),
            Padding(
                padding:
                    EdgeInsets.only(bottom: global.width(context) * 0.0357),
                child: ElevatedButton(
                    onPressed: disableButton ? null : () => _addCity(),
                    child: Text(
                      "Search",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: global.width(context) * 0.04),
                    ))),
            ListView.builder(
              shrinkWrap: true,
              itemCount: cityList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                String description = cityWeatherMap[cityList[index]]
                        ?.weather
                        ?.first
                        .description ??
                    '';
                int tempInt =
                    cityWeatherMap[cityList[index]]?.main?.temp == null
                        ? 0
                        : cityWeatherMap[cityList[index]]!.main!.temp!.round() -
                            273;
                String tempString =
                    '${cityWeatherMap[cityList[index]]?.main?.temp == null ? "" : cityWeatherMap[cityList[index]]!.main!.temp!.round() - 273}°C';

                String tempMin =
                    ' ( ${cityWeatherMap[cityList[index]]?.main?.tempMin == null ? "" : cityWeatherMap[cityList[index]]!.main!.tempMin!.round() - 273}';

                String tempMax =
                    ' - ${cityWeatherMap[cityList[index]]?.main?.tempMax == null ? "" : cityWeatherMap[cityList[index]]!.main!.tempMax!.round() - 273} °C )';

                String humidity =
                    'humidity: ${cityWeatherMap[cityList[index]]?.main?.humidity == null ? "" : cityWeatherMap[cityList[index]]!.main!.humidity}%';

                String speedWind =
                    'wind: ${cityWeatherMap[cityList[index]]?.wind?.speed == null ? "" : cityWeatherMap[cityList[index]]!.main!.humidity}m/s';

                String? iconCode =
                    cityWeatherMap[cityList[index]]?.weather?.first.icon;
                // String date = ;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailsWeather(cityName: cityList[index])),
                    );
                  },
                  splashColor: Colors.blue[800],
                  enableFeedback: true,
                  child: Card(
                    color: AppColors.card,
                    child: ListTile(
                      leading: SizedBox(
                        height: global.height(context) * 0.12,
                        width: global.width(context) * 0.12,
                        child: iconCode != null
                            ? BoxedIcon(getIcon(iconCode: iconCode),
                                color: getColor(iconCode: iconCode),
                                size: global.width(context) * 0.085)
                            : SvgPicture.asset("assets/loading.svg"),
                      ),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                cityList[index],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'ARCADE CLASSIC',
                                    fontSize: 0.025 * global.height(context)),
                              ),
                              SizedBox(width: 0.025 * global.width(context)),
                              Text(
                                tempString,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ARCADE CLASSIC',
                                    fontSize: 0.025 * global.height(context),
                                    color: tempInt >= 20
                                        ? Colors.red
                                        : Colors.lightBlue),
                              ),
                              Text(
                                tempMin,
                                style: TextStyle(
                                    fontFamily: 'ARCADE CLASSIC',
                                    fontSize: 0.025 * global.height(context),
                                    color: Colors.black),
                              ),
                              Text(
                                tempMax,
                                style: TextStyle(
                                    fontFamily: 'ARCADE CLASSIC',
                                    fontSize: 0.025 * global.height(context),
                                    color: Colors.black),
                              ),
                            ]),
                      ),
                      subtitle: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: <Widget>[
                          Text(
                            description,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(width: 0.025 * global.width(context)),
                          Text(
                            humidity,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(width: 0.025 * global.width(context)),
                          Text(speedWind,
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.start)
                        ]),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 0.04 * global.height(context),
            )
          ],
        ),
      ),
    );
  }
}
