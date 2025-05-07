import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Menu {
  final int id;
  final String title;
  final IconData icon;
  final String route;
  final bool selected;

  Menu({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    required this.selected,
  });

  Menu copyWith({
    int? id,
    String? title,
    IconData? icon,
    String? route,
    bool? selected,
  }) {
    return Menu(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      selected: selected ?? this.selected,
    );
  }
}

class MenuProvider extends Notifier<List<Menu>> {
  @override
  List<Menu> build() => [
    Menu(
      id: 0,
      title: 'Noticias',
      icon: Icons.newspaper_rounded,
      route: '/news',
      selected: false,
    ),
    Menu(
      id: 1,
      title: 'Alertas en carreteras',
      icon: Icons.taxi_alert,
      route: '/alerts',
      selected: false,
    ),
    Menu(id: 2, title: 'Inicio', icon: Icons.home, route: '/', selected: true),
    Menu(
      id: 3,
      title: 'Contáctos de Emergencia',
      icon: Icons.perm_phone_msg,
      route: '/contacts',
      selected: false,
    ),
    Menu(
      id: 4,
      title: 'Acerca de',
      icon: Icons.info,
      route: '/about',
      selected: false,
    ),
  ];

  void selectMenu(int id) {
    state =
        state.map((menu) {
          if (menu.id == id) {
            return menu.copyWith(selected: true);
          } else {
            return menu.copyWith(selected: false);
          }
        }).toList();
  }

  int currentMenu() {
    return state.indexWhere((menu) => menu.selected == true);
  }
}

final menuProvider = NotifierProvider<MenuProvider, List<Menu>>(
  MenuProvider.new,
);
