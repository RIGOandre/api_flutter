  import 'dart:convert';

  import 'package:api_flutter/model/personagem.dart';
import 'package:api_flutter/personagens/teladetalhespersonagem.dart';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;

  class Telalistapersonagens extends StatefulWidget {
    const Telalistapersonagens({super.key});

    @override
    _TelalistapersonagensState createState() => _TelalistapersonagensState();
  }

  class _TelalistapersonagensState extends State<Telalistapersonagens> {
    List<Personagem> _personagens = [];
    int _pagina = 1;
    bool _loading = false;
    late ScrollController _scrollController;

    Future<void> _loadPersonagens() async {
      setState(() {
        _loading = true;
      });
      final response = await http.Client().get(Uri.parse('https://rickandmortyapi.com/api/character?page=$_pagina'));

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

        setState(() {
          _personagens.addAll(todosPersonagens);
          _loading = false;
        });
      } else{
        debugPrint('Deu Ruim...');
        setState(() {
          _loading = false;
        });
      }
    }

    void _onScroll() {
      if (_scrollController .offset >= _scrollController.position.maxScrollExtent * 0.9 &&
          !_loading && _pagina <= 42) {
        _pagina++;
        _loadPersonagens();
      }
    }

    @override
    void initState() {
      super.initState();
      _scrollController = ScrollController();
      _scrollController.addListener(_onScroll);
      _loadPersonagens();
    }

    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Lista de Personagens',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepPurple, // cor de fundo da appBar
        ),
        body: ListView.builder(
          controller: _scrollController,
          itemCount: _personagens.length + (_loading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < _personagens.length) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => TelaDetalhesPersonagem(personagem: _personagens[index]))),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_personagens[index].image),
                    ),
                    title: Text(
                      _personagens[index].name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Status: ${_personagens[index].status}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                ),
              );
            }
          },
        ),
      );
    }
  }