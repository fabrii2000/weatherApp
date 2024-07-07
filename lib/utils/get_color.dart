import 'package:flutter/material.dart';

getColor({required String? iconCode}) {
  switch (iconCode) {
    case '01d':
      return Colors.yellow;
    case '01n':
      return Colors.grey;
    case '02d':
      return Colors.grey;
    case '02n':
      return Colors.black54;
    case '03d' || '03n':
      return Colors.grey;
    case '04d' || '04n':
      return Colors.grey;
    case '09d':
      return Colors.yellow;
    case '09n':
      return Colors.black54;
    case '10d':
      return Colors.lightBlue;
    case '10n':
      return Colors.lightBlue;
    case '11d':
      return Colors.black38;
    case '11n':
      return Colors.black54;
    case '13d':
      return Colors.white54;
    case '13n':
      return Colors.white38;
    case '50d':
      return Colors.grey;
    case '50n':
      return Colors.white12;
  }
}
