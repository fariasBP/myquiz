import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myquiz/bloc/play_bloc.dart';
import 'package:myquiz/screens/play_screen.dart';

class ScoreScreen extends StatelessWidget {
  static const routeName = '/score_screen';
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlayBloc, PlayState>(
        builder: (context, state) => SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(((state.qzs.length - state.fails.length) / state.qzs.length) * 100).round()}%',
                          style: TextStyle(fontSize: 42),
                        ),
                        Text(
                          '${state.qzs.length - state.fails.length}/${state.qzs.length} Correctos',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: state.fails
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => ListTile(
                                      leading: Text('${e.key + 1}'),
                                      title: Text(e.value.data.question),
                                      subtitle: Text(
                                        'Respuesta: ${e.value.data.answer}',
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: () {
                        BlocProvider.of<PlayBloc>(
                          context,
                        ).add(LoadQzsPlayEvent(state.packId));
                        Navigator.pushReplacementNamed(
                          context,
                          PlayScreen.routeName,
                        );
                      },
                      child: Text('Reiniciar'),
                    ),
                    SizedBox(height: 12),
                    FilledButton(
                      onPressed: (state.fails.isNotEmpty)
                          ? () {
                              BlocProvider.of<PlayBloc>(context).add(
                                LoadQzsPlayEvent(state.packId, onlyFails: true),
                              );
                              Navigator.pushReplacementNamed(
                                context,
                                PlayScreen.routeName,
                              );
                            }
                          : null,
                      child: Text('Repasar Preguntas Equivocadas'),
                    ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      child: Text('Salir'),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getTotalWrongAnswers() {
    return 0;
  }
}
