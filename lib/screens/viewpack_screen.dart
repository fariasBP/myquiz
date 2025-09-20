import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myquiz/bloc/play_bloc.dart';
import 'package:myquiz/bloc/qz_bloc.dart';
import 'package:myquiz/screens/addqzs_screen.dart';
import 'package:myquiz/screens/play_screen.dart';

class ViewPackScreen extends StatelessWidget {
  static const routeName = '/viewpack_screen';
  const ViewPackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ViewPackArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.packName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AddQzsScreen.routeName,
              arguments: AddQzsArguments(args.packId),
            ),
            icon: Icon(Icons.add_box),
          ),
          IconButton(
            onPressed: () {
              BlocProvider.of<PlayBloc>(
                context,
              ).add(LoadQzsPlayEvent(args.packId));
              Navigator.pushNamed(context, PlayScreen.routeName);
            },
            icon: Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: BlocBuilder<QzBloc, QzState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.qzs
                  .map(
                    (qz) => CardPackWidget(
                      idQz: qz.id,
                      question: qz.data.question,
                      answer: qz.data.answer,
                      fake: qz.data.fake,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

class CardPackWidget extends StatelessWidget {
  const CardPackWidget({
    super.key,
    required this.idQz,
    required this.question,
    required this.answer,
    required this.fake,
  });

  final String idQz;
  final String question;
  final String answer;
  final List<String> fake;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Pregunta: ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Expanded(
                  child: Text(question, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Respuesta: ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Expanded(child: Text(answer, overflow: TextOverflow.ellipsis)),
              ],
            ),
            fake.isEmpty
                ? Container()
                : Text(
                    'Respuestas Falsas:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
            fake.isEmpty
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: fake
                        .map(
                          (f) =>
                              Text('· ${f}', overflow: TextOverflow.ellipsis),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

class ViewPackArguments {
  final String packId;
  final String packName;
  ViewPackArguments(this.packId, this.packName);
}
