import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:myquiz/bloc/play_bloc.dart';
import 'package:myquiz/bloc/qz_bloc.dart';
import 'package:myquiz/screens/addqzs_screen.dart';
import 'package:myquiz/screens/play_screen.dart';

class ViewPackScreen extends StatelessWidget {
  static const routeName = '/viewpack_screen';
  ViewPackScreen({super.key});

  GlobalKey _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ViewPackArguments;
    return Scaffold(
      body: BlocBuilder<QzBloc, QzState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: false,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(args.packName),
                  background: UnDraw(
                    illustration: UnDrawIllustration.questions,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(width: 12),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.folder,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              args.packName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 4),
                            Text(args.description, maxLines: 200),
                            SizedBox(height: 4),
                            Text(
                              '${state.qzs.where((q) => q.data.packId == args.packId).length} Preguntas',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                    ],
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            BlocProvider.of<PlayBloc>(
                              context,
                            ).add(LoadQzsPlayEvent(args.packId));
                            Navigator.pushNamed(context, PlayScreen.routeName);
                          },
                          icon: Icon(Icons.play_arrow),
                        ),
                        IconButton.filled(
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                        ),

                        IconButton.filled(
                          key: _buttonKey,
                          onPressed: () {
                            showMenu(
                              context: context,
                              positionBuilder: (context, constraints) {
                                final RenderBox button =
                                    _buttonKey.currentContext!
                                            .findRenderObject()
                                        as RenderBox;
                                final RenderBox overlay =
                                    Overlay.of(
                                          context,
                                        ).context.findRenderObject()
                                        as RenderBox;
                                final Offset offset = button.localToGlobal(
                                  Offset.zero,
                                  ancestor: overlay,
                                );
                                return RelativeRect.fromLTRB(
                                  offset.dx,
                                  offset.dy + button.size.height,
                                  offset.dx + button.size.width,
                                  offset.dy,
                                );
                              },
                              items: [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.code),
                                    title: Text('Agregar JSON'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        AddQzsScreen.routeName,
                                        arguments: AddQzsArguments(args.packId),
                                      );
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('Eliminar Paquete'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Eliminar Paquete'),
                                            content: Text(
                                              'Se eliminará el paquete y todas las preguntas asociadas. ¿Desea continuar?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                                ),
                                                child: Text('Eliminar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                          icon: Icon(Icons.menu),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),
                  Column(
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
                ]),
              ),
            ],
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
      margin: EdgeInsets.only(bottom: 18, left: 12, right: 12),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              maxLines: 200,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 10),
            Text(answer, maxLines: 200),
            SizedBox(height: 10),
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
                          (f) => Row(
                            children: [
                              Icon(Icons.circle, size: 8),
                              SizedBox(width: 10),
                              Text(f, overflow: TextOverflow.ellipsis),
                            ],
                          ),
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
  final String description;
  ViewPackArguments(this.packId, this.packName, this.description);
}
