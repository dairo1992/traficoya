import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traficoya/providers/noticias_provider.dart';

class Categorias extends ConsumerStatefulWidget {
  const Categorias({super.key, required this.categorias});

  final List<String> categorias;

  @override
  ConsumerState<Categorias> createState() => _CategoriasState();
}

class _CategoriasState extends ConsumerState<Categorias> {
  int selectedCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categorias.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(widget.categorias[index]),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedCategoryIndex = index;
                    ref
                        .read(newsProvider.notifier)
                        .getNewsByCategory(widget.categorias[index]);
                  });
                }
              },
              backgroundColor:
                  isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        },
      ),
    );
  }
}
