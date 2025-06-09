import 'package:chat/models/challenge.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/challenges/challenge_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RetosActualesPage extends StatefulWidget {
  const RetosActualesPage({Key? key}) : super(key: key);

  @override
  _RetosActualesPageState createState() => _RetosActualesPageState();
}

class _RetosActualesPageState extends State<RetosActualesPage> {
  bool _isLoading = true;
  Map<String, Challenge> _retosMap = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final ucService = context.read<UserChallengeService>();
    final chService = context.read<ChallengeService>();

    // 1) Traer los UserChallenges activos
    final userChList = await ucService.getUserChallenges();

    // 2) Descargar cada Challenge por su ID
    final detalles = await Future.wait(
      userChList.map((uc) => chService.getById(uc.challengeId)),
    );

    // 3) Construir el mapa id → Challenge
    final map = { for (var r in detalles) r.id: r };

    setState(() {
      _retosMap = map;
      _isLoading = false;
    });
  }

  String _frequencyLabel(Challenge c) {
    final f = int.tryParse(c.frequency) ?? 1;
    final periodo = {
      'daily': 'día',
      'weekly': 'semana',
      'monthly': 'mes',
      'once': 'una vez',
    }[c.timePeriod.toLowerCase()]!;
    return f > 1 ? '$f veces/$periodo' : periodo;
  }

  String _routeForType(String type) {
    switch (type) {
      case 'counter':           return 'reto_counter';
      case 'inverse_counter':   return 'reto_inverse_counter';
      case 'checklist':         return 'reto_checklist';
      case 'tempo':             return 'reto_tempo';
      case 'crono':             return 'reto_crono';
      case 'single':            return 'reto_unico';
      case 'writing':           return 'reto_writing';
      case 'math':              return 'reto_math';
      case 'questionnaire':     return 'reto_questionnaire';
      default:                  return 'reto_writing';
    }
  }

  Widget buildMiniCard({
    required String title,
    required String frequency,
    required Color backgroundColor,
  }) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: blancoSuave,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              frequency,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: blancoSuave,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ucService = context.watch<UserChallengeService>();

    // Debug logs
    // print('🔍 _isLoading=$_isLoading');
    // print('🔍 retos en mapa: ${_retosMap.keys.toList()}');
    // print('🔍 userChallenges total: ${ucService.items.length}');

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtrar solo los activos que estén en el mapa de retos
    final activos = ucService.items
        .where((u) => u.isActive && _retosMap.containsKey(u.challengeId))
        .toList();

    // // Log detallado
    // debugPrint(
    //   '🔍 activos detallados:\n' +
    //   const JsonEncoder.withIndent('  ').convert(
    //     activos.map((uc) {
    //       final r = _retosMap[uc.challengeId]!;
    //       return {
    //         'challengeId':     uc.challengeId,
    //         'title':           r.title,
    //         'timePeriod':      r.timePeriod,
    //         'frequency':       _frequencyLabel(r),
    //         'user.isActive':   uc.isActive,
    //         'user.currentTotal': uc.currentTotal,
    //         'user.streakDays': uc.streakDays,
    //       };
    //     }).toList(),
    //   ),
    //   wrapWidth: 1024,
    // );

    // Agrupar por periodo
    final mensuales = activos
        .where((u) => _retosMap[u.challengeId]!.timePeriod == 'monthly')
        .toList();
    final semanales = activos
        .where((u) => _retosMap[u.challengeId]!.timePeriod == 'weekly')
        .toList();
    final diarios = activos
        .where((u) => _retosMap[u.challengeId]!.timePeriod == 'daily')
        .toList();

    // print('🔍 activos=${activos.length}');
    // print('🔍 mensuales=${mensuales.length}, semanales=${semanales.length}, diarios=${diarios.length}');


    Widget _buildResponsiveCard({
      required String title,
      required String frequency,
      required Color backgroundColor,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ahora el título puede ocupar hasta 2 líneas
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3, 
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            // const SizedBox(height: 4), 
            // // La frecuencia en una sola línea, centrada
            // Text(
            //   frequency,
            //   textAlign: TextAlign.center,
            //   style: const TextStyle(
            //     fontSize: 12,
            //     color: Colors.white70,
            //   ),
            // ),
          ],
        ),
      );
    }



    Widget buildSection(String label, List items, Color color) {
      if (items.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: Row(
              children: items.map((uc) {
                final reto = _retosMap[uc.challengeId]!;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            _routeForType(reto.type),
                            arguments: reto,
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: _buildResponsiveCard(
                          title: reto.title,
                          frequency: _frequencyLabel(reto),
                          backgroundColor: color,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }



    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: blancoSuave,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Retos en curso",
            style: TextStyle(
              color: negroAbsoluto,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          buildSection("Mensuales", mensuales, dorado),
          buildSection("Semanales", semanales, grisCarbon),
          buildSection("Diarios", diarios, rojoBurdeos),
        ],
      ),
    );
  }
}
