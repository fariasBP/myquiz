import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loon/loon.dart';
import 'package:myquiz/bloc/create_bloc.dart';
import 'package:myquiz/bloc/pack_bloc.dart';
import 'package:myquiz/prefs/pack_model.dart';
import 'package:myquiz/screens/create_pack.dart';

class SelectPack extends StatelessWidget {
  static const String routeName = 'select_pack';
  const SelectPack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Paquete'),
        centerTitle: true,
        actions: [
          FilledButton.tonal(
            onPressed: () => Navigator.pushNamed(context, CreatePack.routeName),
            child: Text('Nuevo'),
          ),
        ],
      ),
      body: BlocBuilder<PackBloc, PackState>(
        builder: (context, state) =>
            ListView(children: _getPacksWidget(context, state.packs)),
      ),
    );
  }

  List<ListTile> _getPacksWidget(
    BuildContext context,
    List<DocumentSnapshot<PackModel>> packs,
  ) {
    return packs
        .map(
          (pack) => ListTile(
            leading: Icon(Icons.category),
            title: Text(pack.data.name),
            subtitle: Text('asdfjkahsuw'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              BlocProvider.of<CreateBloc>(
                context,
              ).add(UpdatePackEvent(idPack: pack.id));
              Navigator.pop(context);
            },
          ),
        )
        .toList();
  }
}
