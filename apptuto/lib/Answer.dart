import 'dart:math';

import 'package:apptuto/GameMaster.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Answer {

  String? image;
  int? idGameMaster;
  int? idQuestion;
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
    String url = '/api/answer/create';
    String data = jsonEncode({'data':{
      'id':params['id'],
      'idGameMaster':params['idGameMaster'],
      'idQuestion':params['idQuestion'],
    }});
    String code = await post( data,url);
    return code;

  }
  Future<String> update(params) async{
    String url = '/api/answer/update';
    String data = jsonEncode({'data':{
      'id':params['id'],
      'idGameMaster':params['idGameMaster'],
      'question':params['question'],
    }});
    String code = await post( data,url);
    return code;

  }
  Future<String> delete(params) async {
    String url = '/api/answer/delete';
    String data = jsonEncode({'data': {
      'id': params['id'],
    }});
    String code = await post(data, url);
    return code;
  }

}