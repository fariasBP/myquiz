import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myquiz/bloc/app_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) => ListView(
        children: [
          SizedBox(height: 70),
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: state.mode == true
                  ? Colors.grey
                  : Colors.grey[300],
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'User Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 50),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Nombre de usuario'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Correo electrónico'),
          ),
          ListTile(leading: Icon(Icons.location_on), title: Text('País')),
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Modo oscuro'),
            trailing: Switch(
              value: state.mode == ThemeMode.dark,
              onChanged: (val) {
                BlocProvider.of<AppBloc>(
                  context,
                ).add(ChangeModeEvent(isDark: val));
              },
            ),
          ),
        ],
      ),
    );
  }
}
