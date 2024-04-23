import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


Widget loadingWidget(){
  return SafeArea(
      minimum: EdgeInsets.fromLTRB(0, 40, 0,0),
      child:Container(
        color: Colors.blue,
        child: SpinKitFadingCircle(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.red : Colors.green,
              ),
            );
          },
        ),
      )
  );
}




