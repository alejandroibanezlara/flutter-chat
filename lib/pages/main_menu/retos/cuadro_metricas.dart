import 'package:flutter/material.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RetoMetricas extends StatelessWidget {
  const RetoMetricas({Key? key}) : super(key: key);

    @override
  Widget build(BuildContext context) {
    // Contenedor principal para el cuadro de métricas
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blancoSuave,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Fila superior de estadísticas
          Row(
            children: [
              Expanded(child: _buildStatItem('144', 'partidas')),
              const SizedBox(width: 8),
              Expanded(child: _buildStatItem('99', '% ganado')),
              const SizedBox(width: 8),
              Expanded(child: _buildStatItem('0:13', 'mejor marca')),
              const SizedBox(width: 8),
              Expanded(child: _buildStatItem('71', 'racha máx.')),
            ],
          ),
          const SizedBox(height: 16),
          // Texto central: racha ganadora
          Column(
            children: const [
              Text(
                '71 días de racha ganadora',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                '¡Pero qué crack!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Barra de progreso de racha (día a día)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDayCircle(true, 'D'),
                const SizedBox(width: 4),
                _buildDayCircle(true, 'L'),
                const SizedBox(width: 4),
                _buildDayCircle(true, 'M'),
                const SizedBox(width: 4),
                _buildDayCircle(false, 'X'),
                const SizedBox(width: 4),
                _buildDayCircle(false, 'J'),
                // Puedes agregar más círculos si es necesario
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Texto de rachas protegidas
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RichText(
                text: const TextSpan(
                  text: '2 ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'rachas protegidas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' disponibles',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Fila de logros / medallas
          Row(
            children: [
              Expanded(child: _buildMedalItem('50 días', 'Prodigio', FontAwesomeIcons.medal, true)),
              const SizedBox(width: 8),
              Expanded(child: _buildMedalItem('100 días', 'Oro', FontAwesomeIcons.shieldHalved, false)),
              const SizedBox(width: 8),
              Expanded(child: _buildMedalItem('150 días', 'Leyenda', FontAwesomeIcons.trophy, false)),
              const SizedBox(width: 8),
              Expanded(child: _buildMedalItem('200 días', 'Invencible', FontAwesomeIcons.crown, false)),
            ],
          ),
          const SizedBox(height: 16),
          // Pregunta final y selector de notificación
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Puedes lograr el estado de Invencible?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Switch(
                    value: true,
                    onChanged: (val) {
                      // Lógica de cambio de estado
                    },
                    activeColor: dorado.withValues(alpha:0.9),
                    inactiveThumbColor: Colors.grey,
                  ),
                  const Flexible(
                    child: Text(
                      'Recibir notificación sobre la partida de mañana',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget auxiliar para construir un ítem de estadística
  static Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Widget auxiliar para construir un círculo que representa un día de racha
  Widget _buildDayCircle(bool isChecked, String dayLetter) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isChecked ? dorado.withValues(alpha:0.9) : grisClaro,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          dayLetter,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Widget auxiliar para construir cada ítem de medalla
  Widget _buildMedalItem(String title, String subtitle, IconData icon, bool success) {
    return Column(
      children: [
        if(success)
        FaIcon(
          icon,
          size: 32,
          color: dorado.withValues(alpha:0.9),
        ),
        if(!success)
        FaIcon(
          icon,
          size: 32,
          color: grisClaro,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}