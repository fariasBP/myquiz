import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loon/loon.dart';
import 'package:myquiz/bloc/app_bloc.dart';
import 'package:myquiz/bloc/create_bloc.dart';
import 'package:myquiz/bloc/pack_bloc.dart';
import 'package:myquiz/bloc/play_bloc.dart';
import 'package:myquiz/bloc/qz_bloc.dart';
import 'package:myquiz/config/app_theme.dart';
import 'package:myquiz/prefs/global.dart';
import 'package:myquiz/screens/addqzs_screen.dart';
import 'package:myquiz/screens/create_pack.dart';
import 'package:myquiz/screens/home_screen.dart';
import 'package:myquiz/screens/play_screen.dart';
import 'package:myquiz/screens/profile_screen.dart';
import 'package:myquiz/screens/score_screen.dart';
import 'package:myquiz/screens/select_pack.dart';
import 'package:myquiz/screens/viewpack_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = GlobalPrefs();
  await prefs.initPrefs();

  Loon.configure(
    persistor: Persistor.current(
      settings: const PersistorSettings(encrypted: true),
    ),
    enableLogging: true,
  );
  await Loon.logger.measure('Hydrate', () => Loon.hydrate());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc()),
        BlocProvider(create: (_) => CreateBloc()),
        BlocProvider(create: (_) => PackBloc()),
        BlocProvider(create: (_) => QzBloc()),
        BlocProvider(create: (_) => PlayBloc()),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'My Quiz',
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
            routes: {
              HomeScreen.routeName: (context) => const HomeScreen(),
              CreatePack.routeName: (context) => CreatePack(),
              SelectPack.routeName: (context) => SelectPack(),
              ViewPackScreen.routeName: (context) => ViewPackScreen(),
              AddQzsScreen.routeName: (context) => AddQzsScreen(),
              PlayScreen.routeName: (context) => PlayScreen(),
              ScoreScreen.routeName: (context) => ScoreScreen(),
              ProfileScreen.routeName: (context) => ProfileScreen(),
            },
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.mode,
          );
        },
      ),
    );
  }
}
