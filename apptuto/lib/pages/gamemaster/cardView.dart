import 'dart:convert';

import 'package:apptuto/AppBars.dart';
import 'package:apptuto/Loading.dart';
import 'package:apptuto/classes/classBarrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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

  Future<void> getGmInfo() async {
    Loading(true);
    String? _string = await FlutterSecureStorage().read(key: 'currentSession');
    Map _map = jsonDecode(_string!);

    GameMaster gm = GameMaster(
        name: _map['name'],
        idGameMaster: _map['idGameMaster'],
        username: _map['username']);
    http.Response response = await gm.getInfo({'id': gm.idGameMaster});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> list =
      jsonDecode(response.body) as Map<String, dynamic>;

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

    return Scaffold(
      appBar: AppUpperBar(counter: counter),
      body: Stack(
        children: [
          Padding(
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
          if (isLoading)
            loadingWidget(),
        ],
      ),
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: AppLowerBarGM(
          pselectedcolor: Color(0x9A4F1BBC),
          punselectedcolor: Color(0xFF2B3031)),
    );
  }
}