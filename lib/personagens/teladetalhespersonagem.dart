import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_flutter/model/personagem.dart';

class TelaDetalhesPersonagem extends StatefulWidget {
  final Personagem personagem;

  const TelaDetalhesPersonagem({required this.personagem, super.key});

  @override
  _TelaDetalhesPersonagemState createState() => _TelaDetalhesPersonagemState();
}

class _TelaDetalhesPersonagemState extends State<TelaDetalhesPersonagem> {
  bool _loading = true;
  late Personagem _detalhesPersonagem;

  @override
  void initState() {
    super.initState();
    _loadDetalhesPersonagem();
  }

  Future<void> _loadDetalhesPersonagem() async {
    final response = await http.Client().get(Uri.parse('https://rickandmortyapi.com/api/character/${widget.personagem.id}'));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      setState(() {
        _detalhesPersonagem = Personagem(
          id: dados['id'],
          name: dados['name'],
          status: dados['status'],
          species: dados['species'],
          type: dados['type'],
          gender: dados['gender'],
          image: dados['image'],
          episodes: dados['episode'].cast<String>(), 
          url: dados['url'],
          created: dados['created'],
        );
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      debugPrint('Erro ao carregar detalhes do personagem');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'personagem.name',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _buildDetalhes(),
    );
  }

  Widget _buildDetalhes() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network(_detalhesPersonagem.image),
          SizedBox(height: 16),
          Text(
            _detalhesPersonagem.name,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text('Status: ${_detalhesPersonagem.status}'),
          Text('Espécie: ${_detalhesPersonagem.species}'),
          Text('Tipo: ${_detalhesPersonagem.type}'),
          Text('Gênero: ${_detalhesPersonagem.gender}'),
          SizedBox(height: 16),
          Text('Episódios:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ..._detalhesPersonagem.episodes.map((episode) => Text(episode)).toList(),
        ],
      ),
    );
  }
}