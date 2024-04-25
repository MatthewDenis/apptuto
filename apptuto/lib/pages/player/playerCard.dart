import 'package:apptuto/AppBars.dart';
import 'package:apptuto/classes/classBarrel.dart';
import 'package:flutter/material.dart';



class PlayerCard extends StatefulWidget {
  Player player;
  PlayerCard({super.key, required this.player});

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  int counter = 1;
  // late AppUpperBar bar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUpperBar(pcolor: Colors.grey[800], counter: counter),
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
              widget.player.name!,
              style: TextStyle(color: Colors.amber[400], fontSize: 20),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: AppLowerBarGM(
          pcolor: Colors.grey[800],
          pselectedcolor: Color(0x9A4F1BBC),
          punselectedcolor: Color(0xFF2B3031)),
    );
  }
}
