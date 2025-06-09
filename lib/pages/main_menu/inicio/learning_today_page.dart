import 'package:chat/pages/shared/colores.dart';
import 'package:chat/pages/shared/microlearning_card/expanded_card_page.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/services/usuarioData/serInvencibleData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/microlearning.dart';
import 'package:chat/services/personalData/microlearning_service.dart';
import 'package:chat/services/auth_service.dart';


/// Página que muestra las tarjetas de microlearning cargadas
class LearningTodayPage extends StatefulWidget {
  const LearningTodayPage({Key? key}) : super(key: key);

  @override
  State<LearningTodayPage> createState() => _LearningTodayPageState();
}

class _LearningTodayPageState extends State<LearningTodayPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMicrolearningsFromDB();
  }

  Future<void> loadMicrolearningsFromDB() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final personalDataService = Provider.of<PersonalDataService>(context, listen: false);
    final microProv = Provider.of<MicrolearningProvider>(context, listen: false);

    try {
      final cards = await personalDataService.getMicrolearningsFromUser(auth.usuario!.uid);
      microProv.setMicrolearnings(cards);
    } catch (e) {
      debugPrint('Error al cargar microlearnings guardados: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final microProv = Provider.of<MicrolearningProvider>(context);
    final microlearnings = microProv.microlearnings;

    return Column(
      children: [
        // ElevatedButton(
        //   onPressed: () async {
        //     final auth = Provider.of<AuthService>(context, listen: false);
        //     final personalDataService = Provider.of<PersonalDataService>(context, listen: false);
        //     final microProv = Provider.of<MicrolearningProvider>(context, listen: false);

        //     final cards = await personalDataService.getRandomMicrolearnings();
        //     final cardIds = cards.map((e) => e.id).toList();

        //     await personalDataService.replaceMicrolearningCards(auth.usuario!.uid, cardIds);

        //     microProv.setMicrolearnings(cards);
        //   },
        //   child: const Text('Cargar microlearnings'),
        // ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (microlearnings.isEmpty)
          const Center(child: Text('Aún no has cargado microlearnings.'))
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: microlearnings.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ExpandableStoryCard(
                    titulo: m.textoCorto,
                    micro: m,
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
          ),
      ],
    );
  }
}