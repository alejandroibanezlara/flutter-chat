import 'package:chat/pages/main_menu/ser_invencible/mis_invencibles_page.dart';
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
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Contenido de $title",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          MisInvenciblesPage(),
          //sectionWidget("Tus invencibles"),
          const SizedBox(height: 16),
          sectionWidget("Herramientas desbloqueadas"),
          const SizedBox(height: 16),
          sectionWidget("Mindset (MANTRAS)"),
          const SizedBox(height: 16),
          sectionWidget("Mi biblioteca"),
          const SizedBox(height: 16),
          sectionWidget("Ranking diario"),
        ],
      ),
    );
  }
}