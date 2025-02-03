import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String? text;
  final margin ;
  final height ;

  const ErrorMessage({Key? key, this.text, this.margin, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(text != null ? text! : "Shared Error !" , textAlign: TextAlign.center,),
      ),
    );
  }
}
