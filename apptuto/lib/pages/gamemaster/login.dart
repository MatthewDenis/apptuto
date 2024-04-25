import 'dart:convert';

import 'package:apptuto/classes/classBarrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;



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
      Navigator.pushReplacementNamed(context, '/gmquestionlist');
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
                                    context, '/gmquestionlist');
                              }
                            }
                          },
                          child: Text('Submit')))
                ],
              ),
            )));
  }
}
