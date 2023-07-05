import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=id&apiKey=938b41d8408649719446b7249d59e3e0');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
      });
    }
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(29, 74, 96, 1),
          title: Text('Berita Hari Ini'),
        ),
        body: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            final title = article['title'];
            final author = article['author'];
            final publishedAt = article['publishedAt'];
            final url = article['url'];

            return Card(
              child: ListTile(
                title: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Author: $author'),
                    Text('Published: $publishedAt'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    launchURL(url);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(29, 74, 96, 0.9),
                  ),
                  child: Text('Lihat Berita'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
