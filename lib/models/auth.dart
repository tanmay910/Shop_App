import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_Exception.dart';
import 'package:async/async.dart';

class Auth with ChangeNotifier {
  String? _tokenId;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer; // this is used to cancel existing timer
  // to ensure that when user login a new timer set

  // we check if user is authenticate or not we check token is valid or not

  bool get isAuth {
    return token == null ? false : true;
  }

  String? get userID {
    return _userId;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCfSrUlpiMDZSnZmYgb8v7XpHgBixNSFOE';
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final jsonData = jsonDecode(response.body);
      if (jsonData['error'] != null) {
        throw httpException(jsonData['error']['message']);
      }
      final responseData = jsonDecode(response.body);
      _tokenId = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];

      autoLogout(); // this to start timer when user login
      notifyListeners();
      final prefs =  await SharedPreferences.getInstance();  // sharedPerferences is used to store data on device
      final userData = jsonEncode({
        'tokenId': _tokenId,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String(),
      });
      prefs.setString('userData', userData);

    } catch (error) {
      throw error;
    }
  }

  String? get token {
    if (_tokenId != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _tokenId != null) {
      return _tokenId;
    }
    return null;
  }

  Future<void> Signup(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _tokenId = null;
    _userId = null;
    _expiryDate = null;
    _authTimer?.cancel();
    notifyListeners();
  }

  Future<bool> tryAutoLogin()async{
    final prefs= await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final jsonString = prefs.getString('userData');
    final extractData= jsonDecode(jsonString!) as Map<String,dynamic>;
    final exiprydate=DateTime.parse(extractData['expiryDate']);


    if(exiprydate.isBefore(DateTime.now())){
      return false;
    }
    _tokenId=extractData['tokenId'];
    _userId=extractData['userId'];
    _expiryDate=exiprydate;
    notifyListeners();
    autoLogout();
    return true;// initialise the timer




  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timetoExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timetoExpiry), () {
      logout();
    });
  }
}
