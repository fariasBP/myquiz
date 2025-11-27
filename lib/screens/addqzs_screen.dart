import 'package:flutter/material.dart';
import 'package:myquiz/config/scripts.dart';
import 'package:myquiz/prefs/qz_model.dart';
import 'package:myquiz/services/qz_services.dart';

class AddQzsScreen extends StatelessWidget {
  static const routeName = '/addqzs_screen';
  AddQzsScreen({super.key});

  final TextEditingController ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AddQzsArguments;

    return Scaffold(
      appBar: AppBar(title: Text('Añadir desde JSON'), centerTitle: true),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: ctrl,
                maxLines: 100,
                decoration: InputDecoration(hintText: 'Pegue su JSON aqui'),
              ),
            ),
            SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    List<QzImport> l = Parsering.parseQuizJson(ctrl.text);
                    return AlertDialog(
                      title: Text('Importar Preguntas'),
                      content: Column(
                        children: [
                          Text('Se importaron ${l.length} preguntas:'),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: l
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e.question),
                                        subtitle: Text(
                                          'Respuesta: ${e.answer}',
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            for (var e in l) {
                              QzServices.createQz(
                                args.packId,
                                e.question,
                                e.answer,
                                e.fake,
                              );
                            }
                            Navigator.pop(context);
                            Navigator.pop(context, l);
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Verificar JSON'),
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class AddQzsArguments {
  final String packId;
  AddQzsArguments(this.packId);
}
