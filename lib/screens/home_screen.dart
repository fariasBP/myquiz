import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myquiz/bloc/app_bloc.dart';
import 'package:myquiz/screens/create_screen.dart';
import 'package:myquiz/screens/discovery_screen.dart';
import 'package:myquiz/screens/profile_screen.dart';
import 'package:myquiz/widgets/menu_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => _getScreen(state.nav),
      ),

      bottomNavigationBar: MenuWidget(),
    );
  }

  Widget _getScreen(int nav) {
    switch (nav) {
      case 0:
        return DiscoveryScreen();
      case 1:
        return CreateScreen();
      case 2:
        return ProfileScreen();
      default:
        return DiscoveryScreen();
    }
  }
}
