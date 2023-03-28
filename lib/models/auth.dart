
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shop_app/models/http_Exception.dart';

class Auth with ChangeNotifier{

   String? _tokenId;
 DateTime? _expiryDate;
  String? _userId;


 // we check if user is authenticate or not we check token is valid or not

 bool  get isAuth{
   return token != null;
 }


String? get token{
   if(_tokenId != null && _expiryDate!.isAfter(DateTime.now()) && _tokenId != null){
     return _tokenId;
   }
   return null;

 }


 Future<void> authenticate(String email, String password,String urlSegment) async
 {
   try{
     final url='https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCfSrUlpiMDZSnZmYgb8v7XpHgBixNSFOE';
     final response = await http.post(Uri.parse(url),body: jsonEncode({
       'email': email,
       'password': password,
       'returnSecureToken': true,
     }));
      final jsonData=jsonDecode(response.body);
     if(jsonData['error'] != null){
       throw httpException(jsonData['error']['message']);
     }
     final responseData=jsonDecode(response.body);
     _tokenId= responseData['idToken'];
     _expiryDate=DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
     _userId=responseData['localId'];

     notifyListeners();
   }catch(error){
     throw error;
   }



 }
  Future<void> Signup(String  email,String password) async
  {
     return authenticate(email, password, 'signUp');
  }


  Future<void> login(String  email,String password) async
  {
    return authenticate(email, password, 'signInWithPassword');
  }


}