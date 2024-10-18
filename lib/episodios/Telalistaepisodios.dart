import 'package:flutter/material.dart';

class Episodio {
  final String nome;
  final String dataLancamento;
  final int numero;

  Episodio({required this.nome, required this.dataLancamento, required this.numero});
}

class Telalistaepisodios extends StatelessWidget {
  final List<Episodio> episodios; // Lista de episódios recebida

  const Telalistaepisodios({Key? key, required this.episodios}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Episódios'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: episodios.length,
        itemBuilder: (context, index) {
          final episodio = episodios[index];
          return ListTile(
            title: Text(episodio.nome),
            subtitle: Text('Data de Lançamento: ${episodio.dataLancamento}'),
            trailing: Text('Episódio: ${episodio.numero}'),
          );
        },
      ),
    );
  }
}