import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DictionaryApp());
}

class DictionaryApp extends StatelessWidget {
  const DictionaryApp({super.key});

  Future<String> getData(String word) async {
    final String url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> definitions = json.decode(response.body);
      if (definitions.isNotEmpty) {
        final Map<String, dynamic> firstEntry = definitions.first;
        final List<dynamic> meanings = firstEntry['meanings'];
        if (meanings.isNotEmpty) {
          final Map<String, dynamic> firstMeaning = meanings.first;
          final List<dynamic> definitionsList = firstMeaning['definitions'];
          if (definitionsList.isNotEmpty) {
            final Map<String, dynamic> firstDefinition = definitionsList.first;
            return "Definitions: ${firstDefinition['definition']}";
          }
        }
      }
      return "No definitions found.";
    } else {

      return "Error: Unable to fetch data from the API";
    }
  }
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DictionaryHomePage(),
    );
  }
}
class DictionaryHomePage extends StatefulWidget {
  @override
  _DictionaryHomePageState createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  String searchQuery = '';
  String result = '';

  void searchDictionary(String query) async {
    final apiResult = await DictionaryApp().getData(query.toLowerCase());
    setState(() {
      result = apiResult;
    });
  }
