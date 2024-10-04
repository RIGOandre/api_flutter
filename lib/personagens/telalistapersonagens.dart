import 'dart:convert';

import 'package:api_flutter/model/personagem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Telalistapersonagens extends StatelessWidget {
  const Telalistapersonagens({super.key});

  Future<List<Personagem>> pageData() async {
    final response = await http.Client().get(Uri.parse('https://rickandmortyapi.com/api/character'));

    if (response.statusCode == 200){
      var dados = json.decode(response.body);
      List dados_result = dados['results'] as List;
      List<Personagem> todosPersonagens = [];

      dados_result.forEach((personagem) {
        todosPersonagens.add(Personagem(
          id: personagem['id'],
          name: personagem ['name'],
          status: personagem ['status'],
          species: personagem['species'],
          type: personagem['type'],
          gender: personagem['gender'],
          image: personagem['image'],
          episodes:[],
          url: personagem ['url'],
          created: personagem['created'],
        ));
      });

      return todosPersonagens;
    } else{
      debugPrint('Deu Ruim...');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Personagens'),
      ),
      body: FutureBuilder(
        future: pageData(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            List<Personagem> listaPersonagens = snapshot.data as List<Personagem>;
            return ListView.builder(
              itemCount: listaPersonagens.length,
              itemBuilder: (context, index) {
                return Text('nome do personagem: ${listaPersonagens[index].name}');
              }
            );
          }else if (snapshot.hasError){
            return Text('Erro: ${snapshot.error}');
          }else{
            return CircularProgressIndicator();
          }
        }
      )
    );
  }
}