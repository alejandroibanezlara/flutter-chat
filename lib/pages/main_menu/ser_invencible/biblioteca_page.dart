import 'package:chat/models/serInvencibleData.dart';
import 'package:chat/models/microlearning.dart';
import 'package:chat/pages/shared/microlearning_card/expanded_card_page.dart';
import 'package:chat/services/usuarioData/serInvencibleData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget que muestra las tarjetas guardadas en la biblioteca del usuario
class LibraryCardList extends StatelessWidget {
  const LibraryCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serService = Provider.of<SerInvencibleService>(context);
    final library = serService.data?.library ?? [];

    if (library.isEmpty) {
      return const Center(child: Text('Tu biblioteca está vacía.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: library.map((m) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ExpandableStoryCard(
              micro: m,
              titulo: m.textoCorto,
              collapsedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.textoCorto,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  if (m.areaInvencibleObj?.icono != null)
                  const SizedBox(height: 8),
                  Center(
                    child: Icon(
                      IconData(int.parse(m.areaInvencibleObj!.icono!), fontFamily: 'MaterialIcons'),
                      size: 30,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              expandedText: m.textoLargo,
              areaTitulo: m.areaInvencibleObj?.titulo,
              areaIconoCodePoint: m.areaInvencibleObj?.icono,
              collapsedWidth: 100,
            ),
          );
        }).toList(),
      ),
    );
  }
}