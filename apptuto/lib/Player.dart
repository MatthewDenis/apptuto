import 'dart:convert';

import 'package:apptuto/GameMaster.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Player{
  String? name;
  String? username;
  String? password;
  int? idPlayer;

  Player({this.name,this.idPlayer,this.username});

Future<String> post(data,url) async {

  final uri = Uri.parse('http://127.0.0.1:8000/'+url);
  final response =await  http.post(uri,
      headers: {"Content-Type": "application/json"},
      body: data
  );
  String statusCode = (response.statusCode).toString();
  return  statusCode;
}

Future<String> create(params) async {
  String url = '/api/player/create';
  String data = jsonEncode({'data':{
    'id':params['id'],
    'name':params['name'],
    'password':params['password'],//deberia ir hasheado pero hule seguridad
  }});
  String code = await post( data,url);
  return code;
  //params
  //name
  //id
  //password
}
Future<String> update(params) async{
  String url = '/api/player/update';
  String data = jsonEncode({'data':{
    'id':params['id'],
    'name':params['name'],
    'password':params['password'],//deberia ir hasheado pero hule seguridad
  }});
  String code = await post( data,url);
  return code;
  //params
  //id
  //nuevo name
  //password
}
Future<String> delete(params) async{
  String url = '/api/player/delete';
  String data = jsonEncode({'data':{
    'id':params['id'],
  }});
  String code = await post( data,url);
  return code;
  //params
  //id
}
Future<String> questionCount(params) async{
  String url = '/api/player/delete';
  String data = jsonEncode({'data':{
    'id':params['id'],
  }});
  String code = await post( data,url);
  return code;
  //params
  //id
}
Future<String> answerCount(params) async{
  String url = '/api/player/answerCount';
  String data = jsonEncode({'data':{
    'id':params['id'],
  }});
  String code = await post( data,url);
  return code;
  //params
  //id
}
Future<String> login(params) async{
  String url = '/api/player/login';
  String data = jsonEncode({'data':{
    'id':params['id'],
    'username':params['username'],
    'password':params['password'],//deberia ir hasheado pero hule seguridad
  }});
  String code = await post( data,url);
  return code;
  //params
  //name
  //password
}
Future<String> signOut(params) async{
  String url = '/api/player/sign_out';
  String data = jsonEncode({'data':{
    'id':params['id'],
  }});
  String code = await post( data,url);
  return code;
  //params
  //id
}
}






