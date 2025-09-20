import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myquiz/bloc/app_bloc.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Theme.of(context).secondaryHeaderColor,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _itemMenu(
              context,
              id: 0,
              isSelected: state.nav == 0,
              icon: FontAwesomeIcons.house,
            ),
            _itemMenu(
              context,
              id: 1,
              isSelected: state.nav == 1,
              icon: FontAwesomeIcons.solidSquarePlus,
            ),
            _itemMenu(
              context,
              id: 2,
              isSelected: state.nav == 2,
              icon: FontAwesomeIcons.chartSimple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemMenu(
    context, {
    required int id,
    required bool isSelected,
    required IconData icon,
  }) {
    return InkWell(
      splashColor: ThemeData().splashColor,
      highlightColor: ThemeData().highlightColor,

      onTap: () {
        BlocProvider.of<AppBloc>(context).add(ChangeNavEvent(index: id));
      },
      child: Container(
        width: 60,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context).disabledColor,
            ),
            isSelected ? SizedBox(height: 6) : Container(),
            isSelected
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).secondaryHeaderColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
