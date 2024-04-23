import 'dart:math';

import 'package:apptuto/GameMaster.dart';
import 'package:apptuto/Loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AppBars.dart';



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





class QuestionAddView extends StatefulWidget{
  const QuestionAddView({super.key});

  @override
  State<QuestionAddView> createState() => _QuestionAddViewState();
}

class _QuestionAddViewState extends State<QuestionAddView>{
  final _formKey = GlobalKey<FormState>();
  String? question;
  bool isLoading = false;

  Future<void> getQuestion(idQuestion,GameMaster gameMaster) async {
    setState(() {
      isLoading = true;
    });
    var question = '';
    http.Response response = await
    gameMaster.getQuestion(
        {
          'idQuestion': idQuestion,
          'idGameMaster':gameMaster.idGameMaster,
        }
    );
    print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> list =
      jsonDecode(response.body) as Map<String, dynamic>;

      if (list['data'].length > 0) {
        setState(() {
          isLoading = false;
          question = list['data'][0]['question'] as String;
        });
      };
    }
  }
  @override
  void initState() {
    super.initState();
    int? idQuestion= (ModalRoute.of(context)?.settings.arguments as Map)['idQuestion'];
    GameMaster gameMaster= (ModalRoute.of(context)?.settings.arguments as Map)['gm'];
    getQuestion(idQuestion,gameMaster);
  }
  @override
  Widget build(BuildContext context) {

    String? answer;
    String question = '';
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
                    Text('Pregunta: ${question}'),

                    Text('Respuesta '),
                    TextFormField(
                      onSaved: (String? value) {
                        answer = value;
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
                                //crear instancia de clase answer con los datos
                                //post a crear respuesta
                                // http.Response response = (await }));

                              //   if (response.statusCode == 200) {
                              //     var data = jsonDecode(response.body)['data'];
                              //
                              //
                              //     Navigator.pushReplacementNamed(
                              //         context, '/gmmode',
                              //         arguments: {'gm': (ModalRoute.of(context)?.settings.arguments as Map)['gm'];
                              //   }
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
}