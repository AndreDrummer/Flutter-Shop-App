import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  DateTime _expireDate;
  String _token;
  String _userId;
  Timer _timeToLogout;

  String get userId {
    return isAuth ? _userId : null;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAPJOeE1U4wbI46kl7nbH6WWLN9oNCaMg0';
    final response = await http.post(
      url,
      body: json.encode(
        {"email": email, "password": password, "returnSecureToken": true},
      ),
    );

    final responseBody = json.decode(response.body);
    print(responseBody);
    if (responseBody["error"] != null) {
      throw AuthException(responseBody["error"]["message"]);
    } else {
      _token = responseBody["idToken"];
      _userId = responseBody["localId"];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBody["expiresIn"],
          ),
        ),
      );

      Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expireDate": _expireDate.toIso8601String()
      });
      _autoLogout();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> signup(String email, String password) {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return Future.value();
    }

    final userData = await Store.getMap('userData');
    if (userData == null) {
      return Future.value();
    }

    final expireDate = DateTime.parse(userData["expireDate"]);    

    if (expireDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    _userId = userData["userId"];
    _token = userData["token"];
    _expireDate = expireDate;

    _autoLogout();
    notifyListeners();

    return Future.value();
  }

  void logout() {
    _token = null;
    _expireDate = null;
    _userId = null;
    if (_timeToLogout != null) {
      _timeToLogout.cancel();
      _timeToLogout = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_timeToLogout != null) {
      _timeToLogout.cancel();
    }
    final secondsToLogout = _expireDate.difference(DateTime.now()).inSeconds;
    _timeToLogout = Timer(Duration(seconds: secondsToLogout), logout);
  }
}
