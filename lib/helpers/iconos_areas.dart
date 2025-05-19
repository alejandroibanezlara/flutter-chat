import 'package:flutter/material.dart';

class AreaIconSelector extends StatefulWidget {
  const AreaIconSelector({Key? key}) : super(key: key);

  @override
  _AreaIconSelectorState createState() => _AreaIconSelectorState();
}

class _AreaIconSelectorState extends State<AreaIconSelector> {
  final List<IconData> areaIcons = [
    Icons.group,           // Empatía y Solidaridad
    Icons.face,            // Carisma
    Icons.check,           // Disciplina
    Icons.assignment,      // Organización
    Icons.autorenew,       // Adaptabilidad
    Icons.image,           // Imagen pulida
    Icons.visibility,      // Visión estratégica
    Icons.money,           // Educación financiera
    Icons.trending_up,     // Actitud de superación
    Icons.chat,            // Comunicación asertiva
  ];

  final Set<int> selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) => _buildIconBox(index)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) => _buildIconBox(index + 5)),
        ),
      ],
    );
  }

  Widget _buildIconBox(int index) {
    final isSelected = selectedIndices.contains(index);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedIndices.remove(index);
          } else {
            selectedIndices.add(index);
          }
        });
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[300] : Colors.transparent,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(areaIcons[index], size: 28),
      ),
    );
  }
}
