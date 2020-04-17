import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:watsonapp/models/corona_case_total_count.dart';
import 'package:watsonapp/models/corona_case_total_count_response.dart';
import 'package:http/http.dart' as http;

class TimeoutException implements Exception {
  final String message = 'Server timeout';
  TimeoutException();
  String toString() => message;
}

class ServerException implements Exception {
  final String message = 'Server busy';
  ServerException();
  String toString() => message;
}

class ServerErrorException implements Exception {
  String message;
  ServerErrorException(this.message);

  String toString() => message;
}

const kTimeoutDuration = Duration(seconds: 25);

class CoronaService {
  CoronaService._privateConstructor();
  static final CoronaService instance = CoronaService._privateConstructor();

  static var baseURL =
      'https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query';

  static String get totalConfirmedCaseURL {
    return '$baseURL?f=json&where=Country_Region%3D\'Colombia\'&Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22,%22onStatisticField%22%3A%22Confirmed%22,%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=false';
  }

  // Country_Region%3D"Colombia"&
  static String get totalRecoveredCaseURL {
    return '$baseURL?f=json&where=Country_Region%3D\'Colombia\'&Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22,%22onStatisticField%22%3A%22Recovered%22,%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=false';
  }

  static String get totalDeathsCaseURL {
    return '$baseURL?f=json&where=Country_Region%3D\'Colombia\'&Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22:%22sum%22,%22onStatisticField%22:%22Deaths%22,%22outStatisticFieldName%22:%22value%22%7D%5D&cacheHint=false';
  }

  Future<CoronaTotalCount> fetchAllTotalCount() async {
    try {
      final confirmedJson = await _fetchJSON(totalConfirmedCaseURL);
      final deathsJson = await _fetchJSON(totalDeathsCaseURL);
      final recoveredJson = await _fetchJSON(totalRecoveredCaseURL);

      final confirmed = CoronaCaseTotalCountResponse.fromJson(confirmedJson)
          .features
          .first
          .attributes
          .value;
      final deaths = CoronaCaseTotalCountResponse.fromJson(deathsJson)
          .features
          .first
          .attributes
          .value;
      final recovered = CoronaCaseTotalCountResponse.fromJson(recoveredJson)
          .features
          .first
          .attributes
          .value;

      if (confirmed == null || deaths == null || recovered == null) {
        throw ServerException();
      }

      return CoronaTotalCount(
          confirmed: confirmed, deaths: deaths, recovered: recovered);
    } on PlatformException catch (_) {
      throw ServerException();
    } on Exception catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static String get globalConfirmedCaseURL {
    return '$baseURL?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22,%22onStatisticField%22%3A%22Confirmed%22,%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=false';
  }

  // Country_Region%3D"Colombia"&
  static String get globalRecoveredCaseURL {
    return '$baseURL?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22,%22onStatisticField%22%3A%22Recovered%22,%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=false';
  }

  static String get globalDeathsCaseURL {
    return '$baseURL?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22:%22sum%22,%22onStatisticField%22:%22Deaths%22,%22outStatisticFieldName%22:%22value%22%7D%5D&cacheHint=false';
  }

  Future<CoronaTotalCount> fetchAllGlobalCount() async {
    try {
      final confirmedJson = await _fetchJSON(globalConfirmedCaseURL);
      final deathsJson = await _fetchJSON(globalDeathsCaseURL);
      final recoveredJson = await _fetchJSON(globalRecoveredCaseURL);

      final confirmed = CoronaCaseTotalCountResponse.fromJson(confirmedJson)
          .features
          .first
          .attributes
          .value;
      final deaths = CoronaCaseTotalCountResponse.fromJson(deathsJson)
          .features
          .first
          .attributes
          .value;
      final recovered = CoronaCaseTotalCountResponse.fromJson(recoveredJson)
          .features
          .first
          .attributes
          .value;

      if (confirmed == null || deaths == null || recovered == null) {
        throw ServerException();
      }

      return CoronaTotalCount(
          confirmed: confirmed, deaths: deaths, recovered: recovered);
    } on PlatformException catch (_) {
      throw ServerException();
    } on Exception catch (e) {
      throw e;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> _fetchJSON(String url) async {
    final response =
        await http.get(url).timeout(Duration(seconds: 25), onTimeout: () {
      throw Error();
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerErrorException("Error retrieving data");
    }
  }
}
