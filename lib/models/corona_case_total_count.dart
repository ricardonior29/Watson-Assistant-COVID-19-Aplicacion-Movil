import 'package:watsonapp/utils/formatter.dart';

class CoronaTotalCount {
  final int confirmed;
  final int deaths;
  final int recovered;

  CoronaTotalCount({this.confirmed, this.deaths, this.recovered});

  String get confirmedText {
    return Formatter.numberFormatter.format(confirmed);
  }

  String get deathsText {
    return Formatter.numberFormatter.format(deaths);
  }

  String get recoveredText {
    return Formatter.numberFormatter.format(recovered);
  }

  int get sick {
    return confirmed - deaths - recovered;
  }

  double get recoveryRate {
    return (recovered.toDouble() / confirmed.toDouble()) * 100;
  }

  double get fatalityRate {
    return (deaths.toDouble() / confirmed.toDouble()) * 100;
  }

  String get sickText {
    return Formatter.numberFormatter.format(sick);
  }

  double get sickRate {
    return (sick.toDouble() / confirmed.toDouble()) * 100;
  }

  String get recoveryRateText {
    return "${recoveryRate.toStringAsFixed(2)}%";
  }

  String get fatalityRateText {
    return "${fatalityRate.toStringAsFixed(2)}%";
  }
}
