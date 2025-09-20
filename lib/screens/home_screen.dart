import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myquiz/bloc/app_bloc.dart';
import 'package:myquiz/screens/create_screen.dart';
import 'package:myquiz/screens/discovery_screen.dart';
import 'package:myquiz/widgets/menu_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) => _getScreen(state.nav),
        ),
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
        return Center(child: Text('Stats Screen'));
      default:
        return DiscoveryScreen();
    }
  }
}
