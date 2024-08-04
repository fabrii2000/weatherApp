import 'package:filter_list/filter_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meteo_app/api_calls/get_weather.dart';
import 'package:meteo_app/utils/app_colors.dart';
import 'package:meteo_app/weather_models/weather_model.dart';
import 'package:meteo_app/widgets/text_field_widget.dart';

import '../utils/filter_const.dart';
import '../utils/get_icon.dart';
import '../utils/global_variable.dart' as global;
import '../widgets/app_bar_widget.dart';
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
    super.initState();
  }

  void openFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 0.9 * global.width(context),
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

  // Future<void> _addCity() async {
  //   if (disableButton) return;
  //   setState(() {
  //     disableButton = true;
  //   });
  //
  //   String cityName = cityController.text.trim().toLowerCase();
  //   if (cityName.isEmpty) {
  //     setState(() {
  //       disableButton = false;
  //     });
  //     return;
  //   }
  //   cityName = cityName[0].toUpperCase() + cityName.substring(1);
  //   print(cityName);
  //
  //   var weatherData = await weatherClient.getData(nameCity: cityName);
  //   setState(() {
  //     if (weatherData != null) {
  //       int existingIndex = cityList.indexOf(cityName);
  //       if (existingIndex != -1 && existingIndex != 0) {
  //         cityList.removeAt(existingIndex);
  //       }
  //       if (existingIndex != 0) {
  //         cityList.insert(0, cityName);
  //       }
  //       cityWeatherMap[cityName] = weatherData;
  //       cityController.clear();
  //       disableButton = false;
  //     }
  //     disableButton = false;
  //   });
  // }
  Future<void> _addCityKeyboard() async {
    String cityName = cityController.text.trim().toLowerCase();
    if (cityName.isEmpty) {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String titleHomePage = "WEATHER";
    return Scaffold(
      appBar: AppBarWidget(
        actions: [Padding(
          padding: const EdgeInsets.only(top: 22.0, right: 15),
          child: SizedBox(
            width: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets?>(EdgeInsets.only(right: 0)),
                backgroundColor: WidgetStateProperty.all<Color>(
                    AppColors.textFieldDarkMode),
                enableFeedback: true,
              ),
              onPressed: openFilterDialog,
              child: Icon(
                size: 25,
                Icons.reorder,
                color: AppColors.grey,
              ),
            ),
          ),
        ),],),
      // drawer: const DrawerWidget(),
      backgroundColor: AppColors.backGroundColorHomeBlack,
      body:  Column(
        children: <Widget>[
          // SizedBox(
          //   height: 0.001 * global.height(context),
          //   child: Row(children: <Widget>[
          //     SizedBox(
          //       width: global.width(context) * 0.39,
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(top: 0.012 * global.height(context)),
          //       child: Text('LOCATION',
          //           style: TextStyle(
          //               color: Colors.black,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 0.024 * global.height(context))),
          //     ),
          //     SizedBox(width: global.width(context) * 0.18),
          //     Transform(
          //       transform: Matrix4(
          //           1,
          //           0,
          //           0,
          //           0,
          //           0,
          //           1,
          //           0,
          //           0,
          //           0,
          //           0,
          //           1,
          //           0,
          //           -global.width(context) * 0.005,
          //           global.width(context) * 0.017,
          //           0,
          //           1),
          //       // child: FittedBox(
          //         // child: ElevatedButton(
          //         //   style: ButtonStyle(
          //         //     backgroundColor: WidgetStateProperty.all<Color>(
          //         //         AppColors.textFieldDarkMode),
          //         //     enableFeedback: true,
          //         //   ),
          //         //   onPressed: openFilterDialog,
          //         //   child: Icon(
          //         //     size: global.width(context) * 0.08,
          //         //     Icons.reorder,
          //         //     color: AppColors.grey,
          //         //   ),
          //         // ),
          //       // ),
          //     ),
          //   ]),
          // ),
          Padding(
              padding: EdgeInsets.only(top: global.width(context) * 0.0357, left: global.width(context) * 0.04,),
              child: TextFieldWidget(
                controller: cityController,
                onSubmitted: _addCityKeyboard(),
                size: [global.height(context)*0.1, global.width(context)*0.9],
              )),
          // Padding(
          //     padding:
          //         EdgeInsets.only(bottom: global.width(context) * 0.0357),
          //     child: ElevatedButton(
          //         style: ButtonStyle(
          //             backgroundColor: WidgetStateProperty.all(
          //                 AppColors.textFieldDarkMode)),
          //         onPressed: disableButton ? null : () => _addCity(),
          //         child: Text(
          //           "Search",
          //           style: TextStyle(
          //               fontWeight: FontWeight.w500,
          //               color: AppColors.grey,
          //               fontSize: global.width(context) * 0.04),
          //         ))),
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: SizedBox(
              height: global.height(context)*0.75,
              width: global.width(context)*0.93,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cityList.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // String description = cityWeatherMap[cityList[index]]
                  //     ?.weather
                  //     ?.first
                  //     .description ??
                  //     '';
                  // int tempInt =
                  //     cityWeatherMap[cityList[index]]?.main?.temp == null
                  //         ? 0
                  //         : cityWeatherMap[cityList[index]]!.main!.temp!.round() -
                  //             273;
                  String tempString =
                      '${cityWeatherMap[cityList[index]]?.main?.temp == null ? "" : cityWeatherMap[cityList[index]]!.main!.temp!.round() - 273}°';

                  // String tempMin =
                  //     ' ( ${cityWeatherMap[cityList[index]]?.main?.tempMin == null ? "" : cityWeatherMap[cityList[index]]!.main!.tempMin!.round() - 273}';
                  //
                  // String tempMax =
                  //     ' - ${cityWeatherMap[cityList[index]]?.main?.tempMax == null ? "" : cityWeatherMap[cityList[index]]!.main!.tempMax!.round() - 273} °C )';

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
                      child: SizedBox(
                        height: global.height(context)*0.13,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(40.0))),
                          color: AppColors.cardBlackMode,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                    child: SizedBox(
                                        height: global.width(context) * 0.10,
                                        width: global.width(context) * 0.10,
                                        child: iconCode != null
                                            ? Center(
                                          child: Icon(
                                            getIcon(iconCode: iconCode),
                                            size:
                                            global.width(context) * 0.10,
                                          ),
                                        )
                                            : CircularProgressIndicator(
                                          color:
                                          AppColors.colorCircularProgress,
                                        )),
                                  ),
                                  SizedBox(
                                    width: global.width(context) * 0.024,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 12.0, top: 6),
                                    child: Text(
                                      cityList[index],
                                      style: TextStyle(
                                          color: AppColors.backGroundColorHomeBlack,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'ARCADE CLASSIC',
                                          fontSize: 0.035 * global.height(context)),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(right: 25, top: 5),
                                    child: Text(
                                      tempString,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'ARCADE CLASSIC',
                                          fontSize: 0.050 * global.height(context),
                                          color:
                                          AppColors.backGroundColorHomeBlack),
                                    ),
                                  )
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: <Widget>[
                                  // Text(
                                  //   description,
                                  //   style: const TextStyle(color: Colors.black),
                                  //   textAlign: TextAlign.start,
                                  // ),
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
                            ],
                          ),
                          //
                        ),
                      ));
                },
              ),
            ),
          ),
          SizedBox(
            height: 0.04 * global.height(context),
          )
        ],
      ),);
  }
}
