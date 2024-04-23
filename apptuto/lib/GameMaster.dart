import 'dart:convert';
import 'dart:async';

import 'package:apptuto/AppBars.dart';
import 'package:apptuto/Loading.dart';
import 'package:apptuto/Question.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apptuto/Player.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  Future<http.Response> getInfo(params)async{
    print(params);
    String url = '/api/game_master/info';
    String data = jsonEncode({
      'idGameMaster': params['idGameMaster'],
    });
    http.Response code = await post(data, url);
    return code;
  }
}

class GMModeView extends StatefulWidget {
  const GMModeView({super.key});

  @override
  State<GMModeView> createState() => _GMModeViewState();
}

class _GMModeViewState extends State<GMModeView> {
  dynamic cards = [];

  bool isLoading = false;

  void Loading(bool param) {
    setState(() {
      isLoading = param;
    });
  }

  Future<dynamic> generateCards() async {
    Loading(true);
    var cards = [];
    String? _string =  await FlutterSecureStorage().read(key:'currentSession');



    Map _map = jsonDecode(_string!);
    GameMaster gm = GameMaster(
        name:_map['name'],
        idGameMaster:( _map['idGameMaster'] as int),
        username: _map['username']
    );

    http.Response response = await gm.getQuestions({'id': gm.idGameMaster});
    if (response.statusCode == 200) {
      Map<String, dynamic> list =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (list['data'].length > 0) {
        for (int index = 0; index < list['data'].length; index++) {
          cards.add(list['data'][index]);
        }
        cards.add({'question': 'fin'});
      } else {
        cards = [
          {'question': 'Sin preguntas'}
        ];
      }
    } else {
      cards = [
        {'question': 'Error'}
      ];
    }
    Loading(false);
    return cards;
  }

  void update(context, gm) {
    Timer.run(() async {
      dynamic tmp = await generateCards();
      setState(() {
        cards = tmp;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.run(() async {
      dynamic tmp = await generateCards();

      setState(() {
        cards = tmp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GameMaster? gm;

    return Scaffold(
      appBar: AppUpperBar(counter: 0),
      backgroundColor: Colors.white60,
      body: Stack(
        children: [
          RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            color: Colors.black,
            backgroundColor: Colors.blue,
            onRefresh: () async {
              // Replace this delay with the code to be executed during refresh
              // and return asynchronous code
              return update(context,
                  (ModalRoute.of(context)?.settings.arguments as Map)['gm']);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Listado de preguntas'),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(children: [
                        SizedBox(
                          height: 550,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: cards
                                .length, // Add one more item for progress indicator
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  return;
                                },
                                child: Card(
                                    color: Colors.blueGrey,
                                    child: Text(cards[index]['question'])),
                              );
                            },
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pushReplacementNamed(
                            context, '/question/add');
                      },
                      child: Text('Agregar Pregunta'),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (isLoading) loadingWidget(),
        ],
      ),
      bottomNavigationBar: AppLowerBarGM(),
    );
  }
}

class GMCardView extends StatefulWidget {
  GMCardView();

  @override
  State<GMCardView> createState() => _GMCardViewState();
}

class _GMCardViewState extends State<GMCardView> {
  int counter = 1;
  bool isLoading = true;
  void Loading(bool bol) {
    setState(() {
      isLoading = bol;
    });
  }
  Future<void> getGmInfo()async{
    Loading(true);
    String? _string =  await FlutterSecureStorage().read(key:'currentSession');
    Map _map = jsonDecode(_string!);

    GameMaster gm = GameMaster(
        name:_map['name'],
        idGameMaster: _map['idGameMaster'] ,
        username: _map['username']
    );
    http.Response response = await gm.getInfo({'id':gm.idGameMaster});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> list =
      jsonDecode(response.body) as Map<String, dynamic>;
      print(list);
    }
      Loading(false);

  }
  // late AppUpperBar bar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGmInfo();
  }

  @override
  Widget build(BuildContext context) {
    GameMaster? gm;

    return Stack(children:[
      Scaffold(
        appBar: AppUpperBar(counter: counter),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NAME',
                style: TextStyle(color: Colors.grey[400], fontSize: 10),
              ),
              Text(
                gm?.name ?? '',
                style: TextStyle(color: Colors.amber[400], fontSize: 20),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[900],
        bottomNavigationBar: AppLowerBarGM(
            pselectedcolor: Color(0x9A4F1BBC),
            punselectedcolor: Color(0xFF2B3031)),
      ),
      if(isLoading)loadingWidget(),
    ]);
  }
}

/////login view

class LoginGmView extends StatefulWidget {
  const LoginGmView({super.key});

  @override
  State<LoginGmView> createState() => _LoginGmViewState();
}

class _LoginGmViewState extends State<LoginGmView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getSession(context);
  }

  Future<void> getSession(context) async {
    if (await FlutterSecureStorage().read(key: 'currentSession') != null) {
      Navigator.pushReplacementNamed(context, '/gmmode');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? password;
    String? username;

    return Scaffold(
        body: Form(
            key: _formKey,
            child: SafeArea(
              minimum: EdgeInsets.fromLTRB(30, 50, 30, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre de usuario'),
                  TextFormField(
                    onSaved: (String? value) {
                      username = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Text('Contrasenha'),
                  TextFormField(
                    onSaved: (String? value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ElevatedButton(
                          onPressed: () async {
                            //   tratar de hacer login
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              GameMaster gm = GameMaster(
                                  username: username, password: password);
                              http.Response response = (await gm.login({
                                'username': username,
                                'password': password
                              }));

                              if (response.statusCode == 200) {
                                var data = jsonDecode(response.body)['data'];
                                GameMaster true_gm = GameMaster(
                                    username: data['username'],
                                    name: data['name'],
                                    password: ' ',
                                    idGameMaster: data['id']);
                                Map _gm_map = {
                                  'username': true_gm.username,
                                  'name': true_gm.name,
                                  'password': true_gm.password,
                                  'idGameMaster': true_gm.idGameMaster
                                };

                                await FlutterSecureStorage().write(
                                    key: 'currentSession',
                                    value: jsonEncode(_gm_map));
                                Navigator.pushReplacementNamed(
                                    context, '/gmmode');
                              }
                            }
                          },
                          child: Text('Submit')))
                ],
              ),
            )));
  }
}
