import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watsonapp/views/stats_col.dart';
import 'package:watsonapp/views/stats_global.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  bool _isLoading = true;
  bool _isGlobal = false;

  @override
  void initState() {
    super.initState();
    _timer();
  }

  void _timer() {
    Timer(
        Duration(milliseconds: 1800),
        () => {
              setState(() {
                _isLoading = false;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeightNoBar = screenHeight - statusBarHeight;
    double realHeight = MediaQuery.of(context).devicePixelRatio * screenHeight;

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    print('height: ' + realHeight.toString());
    double _tabBarHeight = screenHeightNoBar * 0.18;
    double _bodyHeight = screenHeightNoBar * 0.82;

    double _newTabBarHeight = screenHeightNoBar * 0.1;
    double _newBodyHeight = screenHeightNoBar * 0.9;
    Radius _radius = Radius.circular(40);
    Radius _newRadius = Radius.circular(0);
    Widget _statsCol = new StatsColombiaPage();
    Widget _statsGlobal = new StatsGlobalPage();

    double _buttonHeight = 0;
    double _buttonNewHeight2 =
        _isGlobal ? screenHeight * 0.074 : screenHeight * 0.064;
    double _buttonNewHeight1 =
        !_isGlobal ? screenHeight * 0.074 : screenHeight * 0.064;

    Color _shadowColor = Colors.black26;
    Color _shadowSelectColor = Color(0xFF34B5DC);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: statusBarHeight),
            color: Color.fromRGBO(30, 30, 30, 1.0),
            width: screenWidth,
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  height: _isLoading ? _tabBarHeight : _newTabBarHeight,
                  decoration: BoxDecoration(),
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: screenWidth*0.024),
                        child: GestureDetector(
                          onTapDown: (r) {
                            print("back");
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white70,
                            size: 17,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  padding: EdgeInsets.only(top: screenHeight * 0.07),
                  height: _isLoading ? _bodyHeight : _newBodyHeight,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0, color: Color.fromRGBO(254, 254, 254, 1.0)),
                      color: Color.fromRGBO(254, 254, 254, 1.0),
                      borderRadius: BorderRadius.only(
                        topLeft: _isLoading ? _radius : _newRadius,
                        topRight: _isLoading ? _radius : _newRadius,
                      )),
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: _isGlobal ? _statsGlobal : _statsCol,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                margin: EdgeInsets.only(top: _isGlobal? screenHeight * 0.105 : screenHeight * 0.103),
                width: screenWidth * 0.37,
                height: _isLoading ? _buttonHeight : _buttonNewHeight1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGlobal = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _isGlobal ? _shadowColor : _shadowSelectColor,
                          // color:Colors.black26,
                          blurRadius: 5.5,
                          spreadRadius: 0.1,
                          offset: Offset(
                            0.0,
                            3.0,
                          ),
                        )
                      ],
                      border: Border.all(width: 1, color: Colors.transparent),
                      color: Color.fromRGBO(254, 254, 254, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Center(
                      child: Text(
                        "Colombia",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: (realHeight < 1500)
                                ? screenHeight * 0.0243
                                : screenHeight * 0.021,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                duration: Duration(milliseconds: 200),
              ),
              SizedBox(
                width: screenWidth * 0.04,
              ),
              AnimatedContainer(
                margin: EdgeInsets.only(top: _isGlobal? screenHeight * 0.103 : screenHeight * 0.105),
                width: screenWidth * 0.37,
                height: _isLoading ? _buttonHeight : _buttonNewHeight2,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGlobal = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _isGlobal ? _shadowSelectColor : _shadowColor,
                          blurRadius: 5.5,
                          spreadRadius: 0.2,
                          offset: Offset(
                            0.0,
                            3.0,
                          ),
                        )
                      ],
                      border: Border.all(width: 1, color: Colors.transparent),
                      color: Color.fromRGBO(254, 254, 254, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Center(
                      child: Text(
                        "Global",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: (realHeight < 1500)
                                ? screenHeight * 0.0243
                                : screenHeight * 0.021,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                duration: Duration(milliseconds: 200),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
