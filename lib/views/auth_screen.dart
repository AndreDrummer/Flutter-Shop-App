import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 0.5),
                Color.fromRGBO(255, 188, 117, 0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Container(              
                    transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 3
                    ),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade900,                
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Text(
                      "Minha Loja",
                      style: TextStyle(
                          color: Theme.of(context).accentTextTheme.headline6.color,
                          fontFamily: 'Anton',
                          fontSize: 45),
                    ),
                  ),
                  AuthCard()
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
