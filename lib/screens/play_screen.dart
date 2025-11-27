import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myquiz/bloc/play_bloc.dart';
import 'package:myquiz/config/scripts.dart';
import 'package:myquiz/screens/score_screen.dart';

class PlayScreen extends StatelessWidget {
  static const routeName = '/play_screen';
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlayBloc, PlayState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 45),
                        Text(
                          '${state.currentIndex + 1}/${state.qzs.length}',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Parsering.renderParsedContent(
                        Parsering.parseLatexText(
                          state.qzs[state.currentIndex].data.question,
                        ),
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: (state.qzs[state.currentIndex].data.fake.isNotEmpty)
                        ? Column(
                            children: state.options
                                .map(
                                  (qz) => BoxOptionsAnsWidget(
                                    index: state.currentIndex,
                                    option: qz,
                                    answer: state
                                        .qzs[state.currentIndex]
                                        .data
                                        .answer,
                                    show: state.show,
                                  ),
                                )
                                .toList(),
                          )
                        : Container(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        if (state.show) {
                          if (state.currentIndex < state.qzs.length - 1) {
                            BlocProvider.of<PlayBloc>(
                              context,
                            ).add(NextQzPlayEvent());
                          } else {
                            Navigator.pushReplacementNamed(
                              context,
                              ScoreScreen.routeName,
                            );
                          }
                        } else {
                          BlocProvider.of<PlayBloc>(
                            context,
                          ).add(ShowAnswerPlayEvent());
                          BlocProvider.of<PlayBloc>(
                            context,
                          ).add(WrongAnswerPlayEvent(state.currentIndex));
                        }
                      },
                      child: Text(
                        state.show ? 'Siguiente' : 'Mostrar respuesta',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BoxOptionsAnsWidget extends StatelessWidget {
  const BoxOptionsAnsWidget({
    super.key,
    required this.index,
    required this.option,
    required this.answer,
    required this.show,
  });
  final int index;
  final String option;
  final String answer;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: show
          ? () {}
          : () {
              if (option != answer) {
                BlocProvider.of<PlayBloc>(
                  context,
                ).add(WrongAnswerPlayEvent(index));
              }
              BlocProvider.of<PlayBloc>(context).add(ShowAnswerPlayEvent());
            },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: show
              ? (option == answer
                    ? Colors.green.withOpacity(0.5)
                    : Colors.red.withOpacity(0.5))
              : Theme.of(context).colorScheme.surfaceContainer,
          border: Border.all(
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
        ),
        child: Parsering.renderParsedContent(
          Parsering.parseLatexText(option),
          textStyle: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
