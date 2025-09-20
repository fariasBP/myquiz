import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myquiz/bloc/pack_bloc.dart';

class CreatePack extends StatelessWidget {
  static const routeName = '/create_pack';

  CreatePack({super.key});

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Paquete'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre de la categoria:',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                hintText: 'Ejemplo: Tabla de integrales',
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Requerido' : null,
            ),
            Text(
              'Descripcion (Opcional):',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TextFormField(
              controller: _description,
              maxLines: 4,
              decoration: InputDecoration(hintText: 'Descripcion del paquete'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Requerido' : null,
            ),
            SizedBox(height: 12),
            Center(
              child: FilledButton(
                onPressed: () => _createPack(context),
                child: Text('Crear Paquete'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createPack(BuildContext context) {
    if (_name.text.trim() == '' || _description.text.trim() == '') {
      return;
    }

    BlocProvider.of<PackBloc>(
      context,
    ).add(CreatePackEvent(_name.text.trim(), _description.text.trim()));

    Navigator.pop(context);
  }
}
