import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const style =
    TextStyle(color: Colors.black87, fontSize: 35, fontWeight: FontWeight.w900);

const String kGoogleBooksAPIForVolumes =
    'https://www.googleapis.com/books/v1/volumes';

const String kApiKey = 'AIzaSyDAd1WppF3gw788JVAyyiSth6gV80P0TuE';
