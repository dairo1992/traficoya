import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traficoya/providers/emergencias_provider.dart';
import 'package:traficoya/widgets/card_emergencia_contacto.dart';

class EmergenciasScreen extends ConsumerWidget {
  const EmergenciasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredContacts = ref.watch(filteredContactsProvider);
    final tips = ref.watch(tipsProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 110.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Emergencias en Carretera',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade900, Colors.blue.shade700],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.emergency,
                        size: 50,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 320,
                      child: SearchBar(
                        hintText: 'Buscar contacto de emergencia...',
                        onChanged: (value) {
                          ref.read(searchQueryProvider.notifier).state = value;
                        },
                        leading: const Icon(Icons.search),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        elevation: const WidgetStatePropertyAll(3),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showEmergencyTips(context, tips),
                      icon: Icon(
                        Icons.lightbulb_outline,
                        size: 30,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final contact = filteredContacts[index];
                  return EmergencyContactCard(contact: contact);
                }, childCount: filteredContacts.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyTips(BuildContext context, List<Tips> tips) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                tips[index].icon,
                                size: 26,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tips[index].title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(tips[index].content),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: tips.length,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}