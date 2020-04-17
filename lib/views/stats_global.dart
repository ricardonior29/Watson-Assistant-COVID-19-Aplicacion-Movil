import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:watsonapp/apis/corona_service.dart';
import 'package:watsonapp/models/corona_case_total_count.dart';
import 'package:watsonapp/utils/formatter.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsGlobalPage extends StatefulWidget {
  StatsGlobalPage({Key key}) : super(key: key);

  @override
  _StatsGlobalPage createState() => _StatsGlobalPage();
}

class _StatsGlobalPage extends State<StatsGlobalPage>
    with AutomaticKeepAliveClientMixin<StatsGlobalPage> {
  @override
  bool get wantKeepAlive => true;

  var service = CoronaService.instance;
  Future<CoronaTotalCount> _totalCountFuture;

  Color _colMuertes = Color(0xBB7A157B);
  Color _colEnfermos = Color(0xFF0588C0);
  Color _colRecuperados = Color(0xFF34B5DC);
  Color _colConfirmados = Color(0XFFEA3793);

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() {
    _totalCountFuture = service.fetchAllGlobalCount();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double realHeight = MediaQuery.of(context).devicePixelRatio * screenHeight;

    return Container(
      width: screenWidth,
      //color: Colors.lightBlue,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
          future: _totalCountFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                margin: EdgeInsets.only(top: screenHeight * 0.4),
                height: screenHeight * 0.04,
                child: FlareActor("assets/flare/loadingDots.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    animation: "Loading"),
              );
            } else if (snapshot.error != null) {
              return Container(
                margin: EdgeInsets.only(top: screenHeight * 0.4),
                height: screenHeight * 0.04,
                child: Center(
                  child: Text('Error fetching total count data'),
                ),
              );
            } else {
              final CoronaTotalCount totalCount = snapshot.data;

              final data = [
                LinearCases(CaseType.sick.index, totalCount.sick,
                    totalCount.sickRate.toInt(), "Enfermos"),
                LinearCases(CaseType.deaths.index, totalCount.deaths,
                    totalCount.fatalityRate.toInt(), "Muertes"),
                LinearCases(CaseType.recovered.index, totalCount.recovered,
                    totalCount.recoveryRate.toInt(), "Recuperados")
              ];

              final series = [
                charts.Series<LinearCases, int>(
                  id: 'Total Count',
                  domainFn: (LinearCases cases, _) => cases.type,
                  measureFn: (LinearCases cases, _) => cases.total,
                  labelAccessorFn: (LinearCases cases, _) =>
                      '${cases.text}\n${Formatter.numberFormatter.format(cases.count)}',
                  colorFn: (cases, index) {
                    switch (cases.text) {
                      case "Muertes":
                        return charts.ColorUtil.fromDartColor(_colMuertes);
                      case "Enfermos":
                        return charts.ColorUtil.fromDartColor(_colEnfermos);
                      case "Recuperados":
                        return charts.ColorUtil.fromDartColor(_colRecuperados);
                      default:
                        return charts.ColorUtil.fromDartColor(_colConfirmados);
                    }
                  },
                  data: data,
                )
              ];

              return Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.07, right: screenWidth * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Última actualización: ${Formatter.dateFormatter.format(DateTime.now())}",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: (realHeight < 1500)
                              ? screenHeight * 0.022
                              : screenHeight * 0.02,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: screenHeight * 0.013),
                    Text(
                      "Estadísticas globales",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: (realHeight < 1500)
                              ? screenHeight * 0.032
                              : screenHeight * 0.03,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.28,
                        child: charts.PieChart(
                          series,
                          animate: true,
                          defaultRenderer: charts.ArcRendererConfig(
                              arcWidth: 30,
                              arcRendererDecorators: [
                                new charts.ArcLabelDecorator(
                                    outsideLabelStyleSpec:
                                        new charts.TextStyleSpec(
                                      fontSize: (realHeight < 1500)
                                          ? (screenHeight * 0.021).toInt()
                                          : (screenHeight * 0.018).toInt(),
                                    ),
                                    labelPosition:
                                        charts.ArcLabelPosition.outside)
                              ]),
                        )),
                    SizedBox(height: screenHeight * 0.05),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  totalCount.confirmedText,
                                  style: TextStyle(
                                    color: _colConfirmados,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.035
                                        : screenHeight * 0.031,
                                  ),
                                ),
                                Text(
                                  "Confirmados",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.023
                                        : screenHeight * 0.018,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  totalCount.sickText,
                                  style: TextStyle(
                                    color: _colEnfermos,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.035
                                        : screenHeight * 0.031,
                                  ),
                                ),
                                Text(
                                  "Enfermos",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.023
                                        : screenHeight * 0.018,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  totalCount.recoveredText,
                                  style: TextStyle(
                                    color: _colRecuperados,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.035
                                        : screenHeight * 0.031,
                                  ),
                                ),
                                Text(
                                  "Recuperados",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.023
                                        : screenHeight * 0.018,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  totalCount.recoveryRateText,
                                  style: TextStyle(
                                    color: _colRecuperados,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.035
                                        : screenHeight * 0.031,
                                  ),
                                ),
                                Text(
                                  "Recuperación",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.023
                                        : screenHeight * 0.018,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  totalCount.deathsText,
                                  style: TextStyle(
                                    color: _colMuertes,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.035
                                        : screenHeight * 0.031,
                                  ),
                                ),
                                Text(
                                  "Muertes",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.023
                                        : screenHeight * 0.018,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  totalCount.fatalityRateText,
                                  style: TextStyle(
                                    color: _colMuertes,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.035
                                        : screenHeight * 0.031,
                                  ),
                                ),
                                Text(
                                  "Mortalidad",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: (realHeight < 1500)
                                        ? screenHeight * 0.023
                                        : screenHeight * 0.018,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

enum CaseType { confirmed, deaths, recovered, sick }

class LinearCases {
  final int type;
  final int count;
  final int total;
  final String text;

  LinearCases(this.type, this.count, this.total, this.text);
}

class OrdinalCases {
  final String country;
  final int total;
  final CoronaTotalCount totalCount;

  OrdinalCases(this.country, this.total, this.totalCount);
}
