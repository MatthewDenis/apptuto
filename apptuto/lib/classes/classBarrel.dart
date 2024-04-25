import 'dart:convert';
import 'package:http/http.dart' as http;


class User {
  int? age;
  String? name;
  String? email;

  User({this.name, this.email, this.age});
}
class GameMaster {
  String? name;
  String? username;
  int? idGameMaster;
  String? password;
  GameMaster({this.name, this.idGameMaster, this.username, this.password});

  Future<http.Response> post(data, url) async {
    //convertir url
    Uri uri = Uri(scheme: 'http', host: '192.168.5.192', port: 8000, path: url);

    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: data);

    return response;
  }

  Future<http.Response> create(params) async {
    String url = '/api/game_master/create';
    String data = jsonEncode({
      'id': params['id'],
      'name': params['name'],
      'username': params['username'],
      'password': params['password'], //deberia ir hasheado pero hule seguridad
    });
    http.Response code = await post(data, url);
    return code;
    //params
    //name
    //id
    //password
  }

  Future<http.Response> update(params) async {
    String url = '/api/game_master/update';
    String data = jsonEncode({
      'id': params['id'],
      'name': params['name'],
      'password': params['password'], //deberia ir hasheado pero hule seguridad
    });
    http.Response code = await post(data, url);
    return code;
    //params
    //id
    //nuevo name
    //password
  }

  Future<http.Response> delete(params) async {
    String url = '/api/game_master/delete';
    String data = jsonEncode({
      'id': params['id'],
    });
    http.Response code = await post(data, url);
    return code;
    //params
    //id
  }

  Future<http.Response> questionCount(params) async {
    String url = '/api/game_master/delete';
    String data = jsonEncode({
      'id': params['id'],
    });
    http.Response code = await post(data, url);
    return code;
    //params
    //id
  }

  Future<http.Response> answerCount(params) async {
    String url = '/api/game_master/answerCount';
    String data = jsonEncode({
      'id': params['id'],
    });
    http.Response code = await post(data, url);
    return code;
    //params
    //id
  }

  Future<http.Response> login(params) async {
    String url = '/api/game_master/login';
    String data = jsonEncode({
      'username': params['username'],
      'password': params['password'], //deberia ir hasheado pero hule seguridad
    });

    http.Response code = await post(data, url);
    return code;
    //params
    //name
    //password
  }

  Future<http.Response> signOut(params) async {
    String url = '/api/game_master/sign_out';
    String data = jsonEncode({
      'id': params['id'],
    });
    http.Response code = await post(data, url);
    return code;
    //params
    //id
  }

  Future<http.Response> getQuestions(params) async {
    String url = '/api/questions/game_master';
    String data = jsonEncode({
      'id': params['id'],
    });
    http.Response code = await post(data, url);
    return code;
  }

  Future<http.Response> getQuestion(params) async {
    String url = '/api/questions/game_master/specific';
    String data = jsonEncode({
      'idGameMaster': params['idGameMaster'],
      'idQuestion': params['idQuestion'],
    });
    http.Response code = await post(data, url);
    return code;
  }

  Future<http.Response> getInfo(params) async {
    print(params);
    String url = '/api/game_master/info';
    String data = jsonEncode({
      'idGameMaster': params['id'],
    });
    http.Response code = await post(data, url);
    return code;
  }

  Future<http.Response> createQuestion(params) async {
    print(params);
    String url = '/api/questions/create';
    String data = jsonEncode({
      'idGameMaster': params['idGameMaster'],
      'question':params['question']
    });
    http.Response code = await post(data, url);
    return code;
  }


}
class Question {
  String? question;
  String? image;
  int? idGameMaster;
  int? idQuestions;
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
    String url = '/api/question/create';
    String data = jsonEncode({'data':{
      'id':params['id'],
      'idGameMaster':params['idGameMaster'],
      'question':params['question'],
      'image':params['image'],
    }});
    String code = await post( data,url);
    return code;

  }
  Future<String> update(params) async{
    String url = '/api/question/update';
    String data = jsonEncode({'data':{
      'id':params['id'],
      'idGameMaster':params['idGameMaster'],
      'question':params['question'],
      'image':params['image']
    }});
    String code = await post( data,url);
    return code;

  }
  Future<String> delete(params) async {
    String url = '/api/question/delete';
    String data = jsonEncode({'data': {
      'id': params['id'],
    }});
    String code = await post(data, url);
    return code;
  }

}
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


