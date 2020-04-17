//import 'package:flutter/services.dart';

class Colombia {
  final int id;
  final String alias;  
  
  Colombia({this.id, this.alias});  
  
  Colombia.fromJson(Map<String, dynamic> data)

      : id = data['name'],
        alias = data['alias'];
}