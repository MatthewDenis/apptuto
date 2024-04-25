import 'dart:async';
import 'dart:convert';

import 'package:apptuto/AppBars.dart';
import 'package:apptuto/Loading.dart';
import 'package:apptuto/classes/classBarrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class QuestionAddView extends StatefulWidget{
  const QuestionAddView({super.key});

  @override
  State<QuestionAddView> createState() => _QuestionAddViewState();
}

class _QuestionAddViewState extends State<QuestionAddView>{
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;


  void Loading(bool bol) {
    setState(() {
      isLoading = bol;
    });
  }



  @override
  Widget build(BuildContext context) {
    String? question = '';

    GameMaster? gm;

    return Scaffold(
      appBar: AppUpperBar(counter: 0),
      body:SafeArea(
          minimum: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child:Stack(
            children:[
              Form(
                  key: _formKey,
                  child: SafeArea(
                    minimum: EdgeInsets.fromLTRB(30, 50, 30, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pregunta: '),
                        TextFormField(
                          onSaved: (String? value) {
                            question = value;
                          },

                          decoration: const InputDecoration(
                            hintText: '' ,
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
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState?.save();
                                    Loading(true);

                                    String? _string = await FlutterSecureStorage().read(key: 'currentSession');
                                    Map _map = jsonDecode(_string!);

                                    GameMaster gm = GameMaster(
                                        name: _map['name'],
                                        idGameMaster: _map['idGameMaster'],
                                        username: _map['username']);
                                    // try to create question
                                    http.Response response = await gm.createQuestion({
                                      'idGameMaster':gm.idGameMaster,
                                      'question':question
                                    });
                                    String? msg;
                                    if(response.statusCode == 200){
                                      msg = 'Pregunta guardada con exito';
                                    }else{
                                      msg = "error";
                                    }

                                    Navigator.pushReplacementNamed(context, '/gmquestionlist',arguments:{'msg':msg});
                                  }
                                },
                                child: Text('Submit')
                            )
                        )
                      ],
                    ),
                  )
              ),
              if (isLoading) loadingWidget(),
            ],
          )
      ),
      bottomNavigationBar: AppLowerBarGM(
          pselectedcolor: Color(0x9A4F1BBC),
          punselectedcolor: Color(0xFF2B3031)
      ),
    );


  }

  Future<void> getGmInfo(gm) async {
    GameMaster? tmp_gm;

    Loading(true);
    String? _string = await FlutterSecureStorage().read(key: 'currentSession');
    Map _map = jsonDecode(_string!);
    tmp_gm = GameMaster(
        name: _map['name'],
        idGameMaster: _map['idGameMaster'],
        username: _map['username']
    );

    setState((){
      gm = tmp_gm;
    });
    Loading(false);


  }
}