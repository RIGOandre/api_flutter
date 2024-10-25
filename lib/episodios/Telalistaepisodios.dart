// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:api_flutter/model/episodio.dart';
// import 'package:http/http.dart' as http;

// class Telalistaepisodios extends StatefulWidget {
//   const Telalistaepisodios({super.key});

//   @override
//   State<Telalistaepisodios> createState() => _TelalistaepisodiosState();
// }

// class _TelalistaepisodiosState extends State<Telalistaepisodios> {
//   bool isLoading = false;
//   ScrollController _scrollController = ScrollController();
//   int pagina = 1;
//   int paginaMaior = 999;
//   List<Episode> todosepisodios = [];

//   Future<List<Episode>> pageData(int page) async {
//     if (!isLoading && pagina <= paginaMaior) {
//       isLoading = true;
//       final response = await http.Client().get(
//           Uri.parse('https://rickandmortyapi.com/api/episode?page=${page}'));

//       if (response.statusCode == 200) {
//         var dados = json.decode(response.body);
//         List dadosResult = dados['results'] as List;
//         paginaMaior = dados['info']['pages'];

//         dadosResult.forEach((episodios) {
//           todosepisodios.add(Episode(
//             id: episodios['id'],
//             name: episodios['name'],
//             created: episodios['created'],
//             airDate: episodios['air_date'],
//             characters: episodios['characters'],
//             episode: episodios['episode'],
//             url: episodios['url'],
//           ));
//         });

//         isLoading = false;
//         pagina++;
//       } else {
//         debugPrint('Failed to load data');
//         return [];
//       }
//     }

//     return todosepisodios;
//   }

//   @override
//   Widget build(BuildContext context) {
//     _scrollController.addListener(
//       () {
//         if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent * 0.7) {
//           setState(() {
//             pageData(pagina);
//           });
//         }
//       },
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Lista de episodios"),
//       ),
//       body: FutureBuilder(
//         future: pageData(pagina),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             List<Episode> listaepisodios = snapshot.data as List<Episode>;
//             return ListView.builder(
//               controller: _scrollController,
//               itemCount: listaepisodios.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   child: ListTile(
//                     title: Text(
//                       listaepisodios[index].name.toString(),
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(listaepisodios[index].episode.toString()),
//                     trailing: Text(listaepisodios[index].airDate),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
