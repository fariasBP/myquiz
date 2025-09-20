import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loon/loon.dart';
import 'package:myquiz/bloc/pack_bloc.dart';
import 'package:myquiz/bloc/qz_bloc.dart';
import 'package:myquiz/prefs/pack_model.dart';
import 'package:myquiz/screens/viewpack_screen.dart';

class DiscoveryScreen extends StatelessWidget {
  static const String routeName = 'discovery_screen';
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PackBloc, PackState>(
        builder: (context, state) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Explorar', style: Theme.of(context).textTheme.titleLarge),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 8),
              _getPackList(context, state.packs),
            ],
          ),
        ),
      ),
    );
  }

  _getPackList(BuildContext context, List<DocumentSnapshot<PackModel>> packs) {
    return Column(
      spacing: 8,
      children: packs
          .map(
            (pack) => _packCard(
              context,
              packId: pack.id,
              packName: pack.data.name,
              packDescription: pack.data.description,
            ),
          )
          .toList(),
    );
  }

  Card _packCard(
    BuildContext context, {
    required String packId,
    required String packName,
    required String packDescription,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.category),
        title: Text(packName),
        subtitle: Text(packDescription),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          BlocProvider.of<QzBloc>(context).add(LoadQzsEvent(packId));
          Navigator.pushNamed(
            context,
            ViewPackScreen.routeName,
            arguments: ViewPackArguments(packId, packName),
          );
        },
      ),
    );
  }
}
