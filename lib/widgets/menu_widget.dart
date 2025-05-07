import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:traficoya/providers/menu_provider.dart';

class FooterMenu extends ConsumerWidget {
  const FooterMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuList = ref.watch(menuProvider);
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: menu.selected ? Colors.white : Colors.blue.shade900,
                      ),
                      width: 50,
                      height: 50,
                      child: Icon(
                        menu.icon,
                        size: 32,
                        color: menu.selected ? Colors.blue.shade900 : Colors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
        // [
        //   ,
        //   Icon(Icons.taxi_alert),
        //   Icon(Icons.home),
        //   Icon(Icons.perm_phone_msg),
        //   Icon(Icons.info),
        // ],
      ),
    );
  }
}
