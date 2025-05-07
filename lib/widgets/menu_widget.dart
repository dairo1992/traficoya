import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:traficoya/providers/menu_provider.dart';

class FooterMenu extends ConsumerWidget {
  const FooterMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuList = ref.watch(menuProvider);

    return Stack(
      clipBehavior:
          Clip.none, // Importante para que los elementos puedan salir del Stack
      children: [
        // Contenedor base azul
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue.shade900,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              menuList.length,
              (index) => Container(
                width: 50,
                height: 50,
                // Este container es invisible, solo para mantener el espacio
                color: Colors.transparent,
              ),
            ),
          ),
        ),

        // Íconos y círculos sobresalientes
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                menuList
                    .map(
                      (menu) => GestureDetector(
                        onTap: () {
                          context.go(menu.route);
                          ref.read(menuProvider.notifier).selectMenu(menu.id);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          transform:
                              Matrix4.identity()
                                ..translate(0.0, menu.selected ? -15.0 : 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color:
                                  menu.selected
                                      ? Colors.white
                                      : Colors.transparent,
                              boxShadow:
                                  menu.selected
                                      ? [
                                        BoxShadow(
                                          // color: Colors.black.withOpacity(0.2),
                                          color: Colors.black.withValues(alpha: 0.6),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                      : null,
                            ),
                            width: 50,
                            height: 50,
                            child: Icon(
                              menu.icon,
                              size: 28,
                              color:
                                  menu.selected
                                      ? Colors.blue.shade900
                                      : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
