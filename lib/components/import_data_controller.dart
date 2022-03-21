import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:access_challenge/models/products.dart';

/// ImportDataController is a class which does work of saving ProducstImported in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class ImportDataController {
  // Google App Script Web URL.
  static const String URL =
      "https://script.google.com/macros/s/AKfycbzsQ6eCpclgggT2LZP7rjEazDvsZbday3wWkY_Z/exec";

  // Success Status Message
  //static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  /*void submitForm(
      ProducstImported feedbackForm, void Function(String) callback) async {
    try {
      await http.post(Uri.parse(URL), body: feedbackForm.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(Uri.parse(url!)).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }*/

  /// Async function which loads feedback from endpoint URL and returns List.
  //Future<List<ProducstImported>> getProductsList() async {
  Future getProductsList(context) async {
    return await http.get(Uri.parse(URL)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;

      //var jsonFeedback = ProducstImported.fromJson(convert.jsonDecode(response.body)) as Map<String, dynamic>;
      //ProducstImported.fromJson(json);

      //var products = ProducstImported.fromMap(jsonFeedback);
      //return jsonFeedback.map((json) => ProducstImported.fromJson(json)).toList();
      //jsonFeedback.map((json) => ProducstImported.fromMap(json));
      jsonFeedback.map((json) => ProducstImported.fromJson(json)).toList();

      Map<String, dynamic> data = {
        'data': jsonFeedback
      };

      try {
        FirebaseFirestore.instance.collection('Users').doc().set(data);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data was imported successfully.'))
        );

        print(data);
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Somethign went wrong.'))
        );
      }
    });
  }
}