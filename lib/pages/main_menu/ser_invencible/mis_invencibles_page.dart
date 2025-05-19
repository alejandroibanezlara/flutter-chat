import 'package:flutter/material.dart';

class MisInvenciblesPage extends StatelessWidget {
  const MisInvenciblesPage({super.key});

  @override
  Widget build(BuildContext context) {
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Fila que contiene el título y los iconos a la derecha.
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mis invencibles',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                // Lógica para buscar.
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                // Lógica para añadir usuario.
              },
              icon: const Icon(Icons.person_add),
            ),
          ],
        ),
      ],
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 20, // Simula 20 usuarios.
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    'U${index + 1}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'User ${index + 1}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    ),
  ],
);
  }
}