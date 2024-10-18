import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_flutter/model/personagem.dart';

class TelaDetalhesPersonagem extends StatefulWidget {
  final Personagem personagem;

  const TelaDetalhesPersonagem({Key? key, required this.personagem}) : super(key: key);

  @override
  _TelaDetalhesPersonagemState createState() => _TelaDetalhesPersonagemState();
}

class _TelaDetalhesPersonagemState extends State<TelaDetalhesPersonagem> {
  bool _loading = true;
  late Personagem _detalhesPersonagem;
  List<String> _episodiosNomes = []; 

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
      await _loadEpisodiosNomes();
    } else {
      setState(() {
        _loading = false;
      });
      debugPrint('Erro ao carregar detalhes do personagem');
    }
  }

  Future<void> _loadEpisodiosNomes() async {
    List<String> nomes = [];
    for (String url in _detalhesPersonagem.episodes) {
      final response = await http.Client().get(Uri.parse(url));
      if (response.statusCode == 200) {
        var dados = json.decode(response.body);
        nomes.add(dados['name']); 
      } else {
        debugPrint('Erro ao carregar episódio: $url');
      }
    }
    setState(() {
      _episodiosNomes = nomes; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personagem',
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(_detalhesPersonagem.image),
            SizedBox(height: 16),
            Text(
              _detalhesPersonagem.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text('Status: ${_detalhesPersonagem.status}', textAlign: TextAlign.center),
            Text('Espécie: ${_detalhesPersonagem.species}', textAlign: TextAlign.center),
            Text('Tipo: ${_detalhesPersonagem.type}', textAlign: TextAlign.center),
            Text('Gênero: ${_detalhesPersonagem.gender}', textAlign: TextAlign.center),
            const SizedBox(height: 36),
            const Text('Episódios:', style: TextStyle(fontSize : 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ..._episodiosNomes.map((nome) => Text(nome, textAlign: TextAlign.center)).toList(),
          ],
        ),
      ),
    );
  }
}