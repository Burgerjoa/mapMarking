import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';

Future<List<List<dynamic>>> readCsvFile() async {
  final input = File('assets/lamp.csv').openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .toList();

  return fields;
}

const List<Map<String, dynamic>> places = [
  {
    'name': '',
    'latitude': 36.6259014,
    'longitude': 127.0269987,
  },
  {
    'name': 'Place 2',
    'latitude': 36.532700,
    'longitude': 127.024712,
  },
  {
    'name': 'Place 3',
    'latitude': 36.532800,
    'longitude': 127.024812,
  },
  {
    'name': 'Place 4',
    'latitude': 36.532900,
    'longitude': 127.024912,
  },
  {
    'name': 'Place 5',
    'latitude': 36.533000,
    'longitude': 127.025012,
  },
  {
    'name': 'Place 6',
    'latitude': 36.533100,
    'longitude': 127.025112,
  },
  {
    'name': 'Place 7',
    'latitude': 36.533100,
    'longitude': 127.025112,
  },
];
