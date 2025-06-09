import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                       // ← Añadido
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/models/challenge.dart';

class RetoIntroduccionPage extends StatelessWidget {
  final Challenge reto;
  
  const RetoIntroduccionPage({
    Key? key,
    required this.reto,
  }) : super(key: key);

  // Construye un icono descriptivo a partir de un label y un IconData
  Widget buildIcono(String label, IconData icono) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: grisCarbon.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icono, size: 24, color: grisCarbon),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: negroAbsoluto)),
      ],
    );
  }

  // Mapea el string del reto a un IconData (ajusta según tus iconos)
  IconData _iconFromString(String? name) {
    switch (name) {
      case 'check_circle': return FontAwesomeIcons.checkCircle;
      case 'star':         return FontAwesomeIcons.star;
      case 'flag':         return FontAwesomeIcons.flag;
      case 'running':      return FontAwesomeIcons.running;
      default:             return FontAwesomeIcons.questionCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    const currentStep = 0;

    // Lista de iconos de áreas invencibles (si existen)
    final areaIconos = reto.areasSerInvencible
            ?.map((a) => buildIcono(a.titulo, _iconFromString(a.icono)))
            .toList() ??
        [];

    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Acción para ir atrás
            Navigator.of(context).pushNamedAndRemoveUntil(
              'home',                           // Nombre de tu ruta Home
              (Route<dynamic> route) => false,  // Elimina todo lo anterior
            );
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (idx) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (idx <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: grisClaro,
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
                  // Fila 1: icono y título
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: grisCarbon.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: FaIcon(
                            _iconFromString(reto.icon),
                            size: 50,
                            color: grisCarbon,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          reto.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: negroAbsoluto,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Iconos de áreas invencibles
                  if (areaIconos.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: areaIconos,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Descripción (larga o breve)
                  Text(
                    reto.description?.isNotEmpty == true
                        ? reto.description!
                        : reto.shortText,
                    style: const TextStyle(fontSize: 16, color: negroAbsoluto),
                  ),

                  const SizedBox(height: 16),

                  // Botones de acción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            // 1) Registrar la dupla user/challenge
                            await Provider.of<UserChallengeService>(
                              context, listen: false
                            ).createUserChallenge(reto);

                            // 2) Navegar según el tipo de reto
                            switch (reto.type) {
                              case 'counter':
                                Navigator.pushNamed(
                                  context,
                                  'reto_counter',
                                  arguments: reto,
                                );
                                break;
                              case 'inverse_counter':
                                Navigator.pushNamed(
                                  context,
                                  'reto_inverse_counter',
                                  arguments: reto,
                                );
                                break;  
                              case 'checklist':
                                Navigator.pushNamed(
                                  context,
                                  'reto_checklist',
                                  arguments: reto,
                                );
                                break;
                              case 'tempo':
                                Navigator.pushNamed(
                                  context,
                                  'reto_tempo',
                                  arguments: reto,
                                );
                                break;
                              case 'crono':
                                Navigator.pushNamed(
                                  context,
                                  'reto_crono',
                                  arguments: reto,
                                );
                                break;
                              case 'single':
                                Navigator.pushNamed(
                                  context,
                                  'reto_unico',
                                  arguments: reto,
                                );
                                break;
                              case 'writing':
                                Navigator.pushNamed(
                                  context,
                                  'reto_writing',
                                  arguments: reto,
                                );
                                break;
                              case 'math':
                                Navigator.pushNamed(
                                  context,
                                  'reto_math',
                                  arguments: reto,
                                );
                                break;
                              case 'questionnaire':
                                Navigator.pushNamed(
                                  context,
                                  'reto_questionnaire',
                                  arguments: reto,
                                );
                                break;
                              default:
                                Navigator.pushNamed(
                                  context,
                                  'reto_writing',
                                  arguments: reto,
                                );
                                break;
                            }
                          } catch (e) {
                            // Si falla, mostramos un mensaje
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al aceptar el reto: $e'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: negroAbsoluto,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Aceptar el reto',
                          style: TextStyle(fontSize: 16, color: blancoSuave),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: negroAbsoluto, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Recházalo',
                          style: TextStyle(fontSize: 16, color: negroAbsoluto),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
