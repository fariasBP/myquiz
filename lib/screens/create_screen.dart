import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myquiz/bloc/create_bloc.dart';
import 'package:myquiz/config/scripts.dart';
import 'package:myquiz/screens/select_pack.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBloc, CreateState>(
      builder: (context, state) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Crear', style: Theme.of(context).textTheme.titleLarge),
              buildPackSelector(context, state.pack),

              Text('Pregunta:', style: Theme.of(context).textTheme.labelLarge),
              state.question.trim() == ''
                  ? Container()
                  : buildPreview(context, state.question),
              TextFormWidget(
                hint: 'Escriba su pregunta en Tex aqui',
                onChaged: (value) {
                  BlocProvider.of<CreateBloc>(
                    context,
                  ).add(UpdateQuestionEvent(question: value));
                },
              ),
              Text('Respuesta:', style: Theme.of(context).textTheme.labelLarge),
              state.answer.trim() == ''
                  ? Container()
                  : buildPreview(context, state.answer),
              TextFormWidget(
                hint: 'Escriba su respuesta en Tex aqui',
                onChaged: (value) {
                  BlocProvider.of<CreateBloc>(
                    context,
                  ).add(UpdateAnswerEvent(answer: value));
                },
              ),
              Text(
                'Opciones Falsas:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Column(
                children: state.fakeAnswers
                    .asMap()
                    .entries
                    .map(
                      (entry) => TextFormWidget(
                        hint: 'Opcion falsa',
                        lines: 1,
                        onChaged: (value) {
                          BlocProvider.of<CreateBloc>(
                            context,
                          ).add(UpdateFakeEvent(index: entry.key, fake: value));
                        },
                      ),
                    )
                    .toList(),
              ),
              Center(
                child: IconButton(
                  onPressed: () => BlocProvider.of<CreateBloc>(
                    context,
                  ).add(AddFakeEvent(fake: '')),
                  icon: Icon(Icons.add),
                ),
              ),
              Center(
                child: FilledButton(
                  onPressed: () {
                    BlocProvider.of<CreateBloc>(context).add(CreateQzEvent());
                  },
                  child: Text('Crear Pregunta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPackSelector(BuildContext context, String pack) {
    return Row(
      children: [
        Text('Paquete: ', style: Theme.of(context).textTheme.labelLarge),
        Flexible(
          child: Text(
            pack == '' ? 'Ninguna' : pack,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, SelectPack.routeName),
          child: Text('Seleccionar'),
        ),
      ],
    );
  }

  Widget buildPreview(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Previsualizacion:',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: 4),
          Parsering.renderParsedContent(Parsering.parseLatexText(text)),
        ],
      ),
    );
  }
}

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    super.key,
    required this.onChaged,
    required this.hint,
    this.lines = 4,
  });

  final void Function(String)? onChaged;
  final int lines;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: lines,
      decoration: InputDecoration(
        hintText: hint,
        alignLabelWithHint: true,
        prefixIcon: Icon(Icons.question_mark),
      ),
      onChanged: onChaged,
    );
  }
}
