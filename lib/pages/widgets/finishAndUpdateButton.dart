// lib/widgets/finish_challenge_button.dart

import 'package:chat/global/environment.dart';
import 'package:chat/services/personalData/metaData_User_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/models/user_challenge.dart';
import 'package:chat/models/metaData_User.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:diacritic/diacritic.dart';

/// Builder que retorna cualquier tipo de resultado (int, String, etc.)
typedef ResultBuilder = Future<dynamic> Function();
/// Callback opcional antes de finalizar (p.ej. para guardados previos)
typedef VoidFutureCallback = Future<void> Function();

class FinishChallengeButton extends StatelessWidget {
  final Challenge reto;
  final UserChallenge uc;
  final ResultBuilder resultBuilder;
  final VoidFutureCallback? preFinish;
  final bool enabled;
  final String label;

  const FinishChallengeButton({
    Key? key,
    required this.reto,
    required this.uc,
    required this.resultBuilder,
    this.preFinish,
    this.enabled = true,
    this.label = 'Finalizar por hoy',
  }) : super(key: key);


  String sanitizeAreaKey(String title) {
  // 1) Quitar tildes
  final noDiacritics = removeDiacritics(title);
  // 2) Eliminar todos los espacios y caracteres no alfanuméricos
  return noDiacritics.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
}

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled
          ? () async {
              try {
                // 0) Pre-lógica opcional (ej. guardar borrador, animaciones…)
                if (preFinish != null) {
                  await preFinish!();
                }

                // 1) Servicios
                final authService = Provider.of<AuthService>(context, listen: false);
                final personalDataSvc = Provider.of<PersonalDataService>(context, listen: false);
                final ucService = Provider.of<UserChallengeService>(context, listen: false);
                final metaSvc = Provider.of<MetaDataUserService>(context, listen: false);

                // Para metadata de retos/puntos:

                final uid = authService.usuario!.uid;

                // 2) Actualizar contadores globales de PersonalData 
                await personalDataSvc.completeChallenge(
                  uid,
                  reto.timePeriod, // 'daily'|'weekly'|'monthly'|'featured'
                );

                // 3) Registrar resultado en UserChallenge
                final dynamic result = await resultBuilder();
                //DESCOMENTAR ESTA LINEA CUANDO SOLUCIONE EL CONTADOR DE METADATA
                await ucService.finishToday(uc.id, result);

                // 4) Incrementar en MetaDataUser:
                //    • Contador de retos según área
                //    • Puntos de esa área
                // Extraemos la primera área (o 'General' si no la hay)
                final areaObj = (reto.areasSerInvencible != null && reto.areasSerInvencible!.isNotEmpty)
                    ? reto.areasSerInvencible!.first
                    : AreaInvencible(titulo: 'General', icono: '');
                final rawTitulo = areaObj.titulo.replaceAll(' ', '');
                final rawKey = sanitizeAreaKey(areaObj.titulo);
                final retosField  = 'retos$rawKey';   // e.g. 'retosEmpatiaYSolidaridad'
                final puntosField = 'puntos$rawKey';  // e.g. 'puntosEmpatiaYSolidaridad'

                await metaSvc.createOrGet(); 
                // ➤ Incrementar recuento
                await metaSvc.incNumber(
                  userId: uid,
                  field: retosField,
                  delta: 1,
                );
                // ➤ Incrementar puntos
                await metaSvc.incNumber(
                  userId: uid,
                  field: puntosField,
                  delta: reto.points,
                );

                // 5) Recalcular tiempo medio para este tipo de reto
                //    (idealmente el backend debería exponer un endpoint,
                //     pero si quieres hacerlo en el cliente, obtén antes
                //     el objeto MetaDataUser, calcula newAvg = 
                //     (oldAvg*count + result) / (count+1) y usa setDouble)
                //
                // final stats = await metaSvc.getStats(uid);
                // final viejoAvg = stats.tiempoMedio${capitalize(reto.type)};
                // final countPrev = stats.retos${capitalize(reto.type)};
                // final nuevoAvg = (viejoAvg * countPrev + result) / (countPrev + 1);
                // await metaSvc.setDouble(userId: uid, field: 'tiempoMedio${capitalize(reto.type)}', value: nuevoAvg);

                // 6) Navegar a pantalla final
                if (!context.mounted) return;
                Navigator.pushNamed(
                  context,
                  'reto_fin',
                  arguments: {'reto': reto, 'resultado': result},
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error finalizando reto: $e')),
                );
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? rojoBurdeos : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          color: blancoSuave,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Helpers opcionales:
String capitalize(String s) => s.isEmpty 
    ? s 
    : s[0].toUpperCase() + s.substring(1);
