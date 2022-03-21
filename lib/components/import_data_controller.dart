import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:access_challenge/models/products.dart';

class ImportDataController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbzsQ6eCpclgggT2LZP7rjEazDvsZbday3wWkY_Z/exec";

  Future getProductsList(context) async {
    return await http.get(Uri.parse(URL)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      
      jsonFeedback.map((json) => ProducstImported.fromJson(json)).toList();

      Map<String, dynamic> data = {
        'data': jsonFeedback
      };

      try {
        FirebaseFirestore.instance.collection('Users').doc().set(data);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data was imported successfully.'))
        );
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Somethign went wrong.'))
        );
      }
    });
  }
}