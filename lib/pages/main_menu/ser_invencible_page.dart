import 'package:chat/pages/main_menu/ser_invencible/biblioteca_page.dart';
import 'package:chat/pages/main_menu/ser_invencible/mindset_page.dart';
import 'package:chat/pages/main_menu/ser_invencible/mis_invencibles_page.dart';
import 'package:chat/pages/main_menu/ser_invencible/ranking_page.dart';
import 'package:chat/pages/main_menu/ser_invencible/tools_page.dart';
import 'package:flutter/material.dart';


class SerInvenciblePage extends StatelessWidget {
  const SerInvenciblePage({Key? key}) : super(key: key);

  // Widget auxiliar para crear cada sección (Título - Divider - Container)
  Widget sectionWidget(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Divider para separar el título del contenido
        const Divider(color: Colors.grey),
        // Container representativo del contenido de la sección

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        key: const PageStorageKey('SerInvenciblePageList'),
        padding: const EdgeInsets.all(16.0),
        children: [
          MisInvenciblesPage(key: const PageStorageKey('MisInvenciblesPage')),

          const SizedBox(height: 16),
          ToolsPage(key: const PageStorageKey('ToolsPage')),
          const SizedBox(height: 16),

          MindsetPage(key: const PageStorageKey('MindsetPage')),
          const SizedBox(height: 16),
          sectionWidget("Mi biblioteca"),
          // ExpandableStoryCard(collapsedText: 'collapsedText', expandedText: 'asdfasdfasdfhjasdfljkadshjlkadsf'),
          LibraryCardList(key: const PageStorageKey('LibraryCardList')),
          const SizedBox(height: 16),
          sectionWidget("Ranking diario"),
          DailySummaryView(key: const PageStorageKey('DailySummaryView')),
        ],
      ),
    );
  }
}