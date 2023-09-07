import 'dart:io';

import 'package:csv/csv.dart';

File readCSV() {
  var csvFile = File('assets/abc.csv');
  var csvString = csvFile.readAsString();
  var csvData = CsvToListConverter();
  return csvFile;
}

List<Map<String, dynamic>> places = [
  {'name': '', 'latitude': 37.532600, 'longitude': 127.024612},
];

Future<void> main() async {
  readCSV();
}

List<Map<String, dynamic>> getPlaces() {
  return places;
}
