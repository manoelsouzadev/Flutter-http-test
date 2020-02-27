import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data;
  final String url = "https://unsplash.com/napi/photos/Q14J2k8VE3U/related";

  Future<String> getJSONData() async {
    var response = await http.get(url);
    setState(() {
      data = json.decode(response.body)['results'];
    });
    return "Dados obtidos com sucesso!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: _listView(),
    );
  }

  _listView() {
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return _exibirImagem(data[index]);
      },
    );
  }

  _exibirImagem(dynamic item) => Container(
        decoration: BoxDecoration(color: Colors.white),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: item['urls']['small'],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fadeOutDuration: Duration(seconds: 2),
              fadeInDuration: Duration(seconds: 3),
            ),
            _criaLinhaTexto(item),
          ],
        ),
      );

  _criaLinhaTexto(dynamic item) => ListTile(
        title: Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              item['description'] == null ? '' : item['description'],
              textAlign: TextAlign.justify,
            )),
        subtitle: Padding(
            padding: EdgeInsets.all(4),
            child: Text("Likes : " + item['likes'].toString())),
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getJSONData();
  }
}
