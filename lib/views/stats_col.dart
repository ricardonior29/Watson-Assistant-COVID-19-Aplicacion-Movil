import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:watsonapp/apis/corona_service.dart';
import 'package:watsonapp/models/corona_case_total_count.dart';
import 'package:watsonapp/utils/formatter.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class StatsColombiaPage extends StatefulWidget {
  StatsColombiaPage({Key key}) : super(key: key);

  @override
  _StatsColombiaPage createState() => _StatsColombiaPage();
}

class _StatsColombiaPage extends State<StatsColombiaPage>
    with AutomaticKeepAliveClientMixin<StatsColombiaPage> {
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
    _totalCountFuture = service.fetchAllTotalCount();
  }

  Widget _circle = new Container(
    width: 30.0,
    height: 30.0,
    decoration: new BoxDecoration(
        shape: BoxShape.circle, border: Border.all(color: Colors.transparent)),
    child: ClipOval(
      child: WaveWidget(
        waveFrequency: 1.6,
        waveAmplitude: 0,
        size: Size(50, 50),
        config: CustomConfig(
          gradients: [
            [Colors.yellow, Colors.yellow],
            [Colors.blue, Colors.blue],
            [Colors.red, Colors.red]
          ],
          durations: [35000, 19440, 10800],
          heightPercentages: [0.1, 0.4, 0.7],
          gradientBegin: Alignment.bottomLeft,
          gradientEnd: Alignment.topRight,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double realHeight = MediaQuery.of(context).devicePixelRatio * screenHeight;

    return Container(
      width: screenWidth,
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
              double totalRate =
                  totalCount.recoveryRate + totalCount.fatalityRate;
              double recoveryRate = (totalCount.recoveryRate * 100) / totalRate;
              double fatalityRate = (totalCount.fatalityRate * 100) / totalRate;

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _circle,
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              "Estadísticas nacionales",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: (realHeight < 1500)
                                      ? screenHeight * 0.032
                                      : screenHeight * 0.03,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                                height: screenHeight * 0.1,
                                image: AssetImage(
                                    "assets/images/icon_people.png")),
                            SizedBox(height: screenHeight * 0.008),
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
                              "Casos Confirmados",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: (realHeight < 1500)
                                    ? screenHeight * 0.023
                                    : screenHeight * 0.018,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.013),
                        Divider(),
                        SizedBox(height: screenHeight * 0.013),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Image(
                                    height: screenHeight * 0.06,
                                    image: AssetImage(
                                        "assets/images/icon_sick.png")),
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
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image(
                                    height: screenHeight * 0.06,
                                    image: AssetImage(
                                        "assets/images/icon_care.png")),
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
                            Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image(
                                    height: screenHeight * 0.06,
                                    image: AssetImage(
                                        "assets/images/icon_tomb.png")),
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
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: screenHeight * 0.02,
                              width: (screenWidth - (screenWidth * 0.07 * 2)) *
                                  recoveryRate /
                                  100,
                              color: _colRecuperados,
                            ),
                            Container(
                              height: screenHeight * 0.02,
                              width: (screenWidth - (screenWidth * 0.07 * 2)) *
                                  fatalityRate /
                                  100,
                              color: _colMuertes,
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
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
                                    "Tasa de recuperación",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (realHeight < 1500)
                                          ? screenHeight * 0.023
                                          : screenHeight * 0.018,
                                    ),
                                  )
                                ],
                              ),
                              Column(
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
                                    "Tasa de mortalidad",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: (realHeight < 1500)
                                          ? screenHeight * 0.023
                                          : screenHeight * 0.018,
                                    ),
                                  )
                                ],
                              )
                            ])
                      ]));
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
