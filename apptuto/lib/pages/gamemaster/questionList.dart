import 'dart:async';
import 'dart:convert';

import 'package:apptuto/AppBars.dart';
import 'package:apptuto/Loading.dart';
import 'package:apptuto/classes/classBarrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GMQuestionListView extends StatefulWidget {
  const GMQuestionListView({super.key});

  @override
  State<GMQuestionListView> createState() => _GMQuestionListViewState();
}

class _GMQuestionListViewState extends State<GMQuestionListView> {
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
    String? _string = await FlutterSecureStorage().read(key: 'currentSession');

    Map _map = jsonDecode(_string!);
    GameMaster gm = GameMaster(
        name: _map['name'],
        idGameMaster: (_map['idGameMaster'] as int),
        username: _map['username']);

    http.Response response = await gm.getQuestions({'id': gm.idGameMaster});
    if (response.statusCode == 200) {
      Map<String, dynamic> list =
      jsonDecode(response.body) as Map<String, dynamic>;

      if (list['data'].length > 0) {
        for (int index = 0; index < list['data'].length; index++) {

          cards.add(list['data'][index]);


        }
        cards.add({'question': '- - - - - Fin - - - - -'});
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

  Future<void> update() async {
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            color: Colors.black,
            backgroundColor: Colors.blue,
            onRefresh: () async {
              Loading(true);
              await update();
              Loading(false);
            },

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Listado de preguntas'),
                Column(children: [
                  SizedBox(
                    height: 550,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: cards
                          .length, // Add one more item for progress indicator
                      itemBuilder: (BuildContext context, int index) {
                        if (cards.length - 1 > index){

                          return GestureDetector(
                            onTap: () {
                              return;
                            },
                            child:Card(
                                color: Colors.blueGrey,
                                child:  Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(cards[index]['question']),
                                )),

                          );
                        }else{
                          return Center(child:Text(cards[index]['question']));
                        }
                      },
                    ),
                  ),
                ]),
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